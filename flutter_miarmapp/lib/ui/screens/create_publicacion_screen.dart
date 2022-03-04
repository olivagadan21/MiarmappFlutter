import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_miarmapp/bloc/bloc_publicaciones/bloc_publicaciones_bloc.dart';
import 'package:flutter_miarmapp/bloc/image_pick_bloc/image_pick_bloc_bloc.dart';
import 'package:flutter_miarmapp/models/publicacion_dto.dart';
import 'package:flutter_miarmapp/models/publicacion_model.dart';
import 'package:flutter_miarmapp/repository/publicacion_repository/publicacion_repository.dart';
import 'package:flutter_miarmapp/repository/publicacion_repository/publicacion_repository_impl.dart';
import 'package:flutter_miarmapp/style/styles.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'menu_screen.dart';

class PublicacionScreen extends StatefulWidget {
  const PublicacionScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<PublicacionScreen> {
  String imageSelect = "Imagen no selecionada";
  FilePickerResult? result;
  PlatformFile? file;

  String date = "";
  DateTime selectedDate = DateTime.now();

  late PublicacionRepository _publicacionRepository;
  final _formKey = GlobalKey<FormState>();
  TextEditingController titulo = TextEditingController();
  TextEditingController texto = TextEditingController();
  TextEditingController estadoPublicacion = TextEditingController();
  late Future<SharedPreferences> _prefs;
  final String uploadUrl = 'http://10.0.2.2:8080/auth/register';
  String path = "";
  bool isPublic = true;

  @override
  void initState() {
    _publicacionRepository = PublicacionRepositoryImpl();
    _prefs = SharedPreferences.getInstance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              return ImagePickBlocBloc();
            },
          ),
          BlocProvider(
            create: (context) {
              return BlocPublicacionesBloc(_publicacionRepository);
            },
          ),
        ],
        child: _createBody(context),
      ),
    );
  }

  _createBody(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<BlocPublicacionesBloc, BlocPublicacionesState>(
                listenWhen: (context, state) {
              return state is PublicacionesSuccessState ||
                  state is PublicacionErrorState;
            }, listener: (context, state) async {
              if (state is PublicacionesSuccessState) {
                _createSuccess(context, state.loginResponse);
              } else if (state is PublicacionErrorState) {
                _showSnackbar(context, state.message);
              }
            }, buildWhen: (context, state) {
              return state is BlocPublicacionesInitial ||
                  state is PublicacionesLoading;
            }, builder: (ctx, state) {
              if (state is BlocPublicacionesInitial) {
                return _create(ctx);
              } else if (state is PublicacionesLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return _create(ctx);
              }
            })),
      ),
    );
  }

  Future<void> _createSuccess(
      BuildContext context, PublicacionData late) async {
    _prefs.then((SharedPreferences prefs) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MenuScreen()),
      );
    });
  }

  void _showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _create(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create New Publication',
                    style: heading2.copyWith(color: textBlack),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        controller: titulo,
                        decoration: InputDecoration(
                          hintText: 'Titulo',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        controller: texto,
                        decoration: InputDecoration(
                          hintText: 'Texto',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: textWhiteGrey,
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          child: TextFormField(
                            controller: estadoPublicacion,
                            decoration: InputDecoration(
                              hintText: 'Nick',
                              hintStyle: heading6.copyWith(color: textGrey),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    BlocConsumer<ImagePickBlocBloc, ImagePickBlocState>(
                        listenWhen: (context, state) {
                          return state is ImageSelectedSuccessState;
                        },
                        listener: (context, state) {},
                        buildWhen: (context, state) {
                          return state is ImagePickBlocInitial ||
                              state is ImageSelectedSuccessState;
                        },
                        builder: (context, state) {
                          if (state is ImageSelectedSuccessState) {
                            path = state.pickedFile.path;
                            print('PATH ${state.pickedFile.path}');
                            return Column(children: [
                              Image.file(
                                File(state.pickedFile.path),
                                height: 100,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                  ),
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString('file', path);
                                  },
                                  child: const Text('Cargar Imagen'))
                            ]);
                          }
                          return Center(
                              child: ElevatedButton(
                                  onPressed: () {
                                    BlocProvider.of<ImagePickBlocBloc>(context)
                                        .add(const SelectImageEvent(
                                            ImageSource.gallery));
                                  },
                                  child: const Text('Seleccionar Imagen')));
                        })
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  SizedBox(
                    width: 12,
                  ),
                ],
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(240, 50), primary: Colors.blue),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    if (_formKey.currentState!.validate()) {
                      final loginDto = PublicacionDto(
                          titulo: titulo.text,
                          texto: texto.text,
                          estadoPublicacion: true);
                      BlocProvider.of<BlocPublicacionesBloc>(context)
                          .add(DoPublicacionEvent(loginDto, path));
                    }
                    prefs.setString('titulo', titulo.text);
                    prefs.setString('texto', texto.text);
                    prefs.setString('estadoPublicacion', true.toString());
                  },
                  child: const Text('Create New'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
