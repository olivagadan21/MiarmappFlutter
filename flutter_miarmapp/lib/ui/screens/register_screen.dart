import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_miarmapp/bloc/bloc/register_bloc.dart';
import 'package:flutter_miarmapp/bloc/image_pick_bloc/image_pick_bloc_bloc.dart';
import 'package:flutter_miarmapp/models/register_dto.dart';
import 'package:flutter_miarmapp/models/register_response.dart';
import 'package:flutter_miarmapp/repository/auth_repository/auth_repository.dart';
import 'package:flutter_miarmapp/repository/auth_repository/auth_repository_impl.dart';
import 'package:flutter_miarmapp/style/styles.dart';
import 'package:flutter_miarmapp/ui/screens/login_screen.dart';
import 'package:image_picker/image_picker.dart';

import 'package:date_field/date_field.dart';

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String imageSelect = "Imagen no selecionada";
  FilePickerResult? result;
  PlatformFile? file;

  String date = "";
  DateTime selectedDate = DateTime.now();

  late AuthRepository authRepository;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nombre = TextEditingController();
  TextEditingController apellidos = TextEditingController();
  TextEditingController nick = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fechaNacimiento = TextEditingController();
  TextEditingController rol = TextEditingController();
  TextEditingController password2 = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late Future<SharedPreferences> _prefs;
  final String uploadUrl = 'http://10.0.2.2:8080/auth/register';
  String path = "";
  bool _passwordVisible = false;
  bool _password2Visible = false;
  bool isPublic = true;

  @override
  void initState() {
    authRepository = AuthRepositoryImpl();
    _prefs = SharedPreferences.getInstance();
    _passwordVisible = false;
    _password2Visible = false;
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
              return RegisterBloc(authRepository);
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
            child: BlocConsumer<RegisterBloc, RegisterState>(
                listenWhen: (context, state) {
              return state is RegisterSuccessState || state is LoginErrorState;
            }, listener: (context, state) async {
              if (state is RegisterSuccessState) {
                _registerSuccess(context, state.loginResponse);
              } else if (state is LoginErrorState) {
                _showSnackbar(context, state.message);
              }
            }, buildWhen: (context, state) {
              return state is RegisterInitial || state is RegisterLoading;
            }, builder: (ctx, state) {
              if (state is RegisterInitial) {
                return _register(ctx);
              } else if (state is RegisterLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return _register(ctx);
              }
            })),
      ),
    );
  }

  Future<void> _registerSuccess(
      BuildContext context, RegisterResponse late) async {
    _prefs.then((SharedPreferences prefs) {
      prefs.setString('token', late.email);
      prefs.setString('id', late.id);
      prefs.setString('avatar', late.avatar);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  void _showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _register(BuildContext context) {
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
                    'Registrarse',
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
                        controller: nombre,
                        decoration: InputDecoration(
                          hintText: 'Nombre',
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
                        controller: apellidos,
                        decoration: InputDecoration(
                          hintText: 'Apellidos',
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
                        controller: nick,
                        decoration: InputDecoration(
                          hintText: 'Nick',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: ToggleSwitch(
                        cornerRadius: 20.0,
                        activeBgColors: [
                          [Colors.green[600]!],
                          [Colors.red[600]!]
                        ],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey,
                        inactiveFgColor: Colors.white,
                        initialLabelIndex: 0,
                        totalSwitches: 2,
                        labels: const ['Público', 'Privado'],
                        radiusStyle: true,
                        onToggle: (index) {
                          index == 0
                              ? isPublic = true
                              : isPublic = false;
                          print('switched to: $isPublic');
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: DateTimeFormField(
                        initialDate: DateTime(2002, 9, 20),
                        firstDate: DateTime.utc(1900),
                        lastDate: DateTime.now(),
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.black45),
                          errorStyle: TextStyle(color: Colors.redAccent),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: Icon(Icons.event_note),
                          labelText: 'Fecha de nacimiento',
                        ),
                        mode: DateTimeFieldPickerMode.date,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (e) => (e?.day ?? 0) == 1
                            ? 'Please not the first day'
                            : null,
                        onDateSelected: (DateTime value) {
                          selectedDate = value;
                          print(value);
                        },
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
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
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
                            obscureText: !_passwordVisible,
                            controller: passwordController,
                            decoration: InputDecoration(
                              hintText: 'Contraseña',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
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
                            obscureText: !_password2Visible,
                            controller: password2,
                            decoration: InputDecoration(
                                hintText: 'Confirmar Contraseña',
                                hintStyle: heading6.copyWith(color: textGrey),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _password2Visible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _password2Visible = !_password2Visible;
                                    });
                                  },
                                )),
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final loginDto = RegisterDto(
                          nombre: nombre.text,
                          apellidos: apellidos.text,
                          nick: nick.text,
                          fechaNacimiento:
                              DateFormat("yyyy-MM-dd").format(selectedDate),
                          rol: isPublic,
                          email: emailController.text,
                          password2: password2.text,
                          password: passwordController.text);

                      BlocProvider.of<RegisterBloc>(context)
                          .add(DoRegisterEvent(loginDto, path));
                    }
                  },
                  child: const Text('Registrarse'),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "¿Ya tienes una cuenta? ",
                    style: regular16pt.copyWith(color: textGrey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      'Iniciar sesión',
                      style: regular16pt.copyWith(color: primaryBlue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
