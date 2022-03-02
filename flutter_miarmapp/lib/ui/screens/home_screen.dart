import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_miarmapp/bloc/bloc_publicaciones/bloc_publicaciones_bloc.dart';
import 'package:flutter_miarmapp/models/publicacion_model.dart';
import 'package:flutter_miarmapp/repository/constants.dart';
import 'package:flutter_miarmapp/repository/publicacion_repository/publicacion_repository.dart';
import 'package:flutter_miarmapp/repository/publicacion_repository/publicacion_repository_impl.dart';
import 'package:flutter_miarmapp/ui/widgets/error_page.dart';
import 'package:flutter_miarmapp/ui/widgets/home_app_bar.dart';
import 'package:insta_like_button/insta_like_button.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PublicacionRepository publicacionRepository;

  @override
  void initState() {
    publicacionRepository = PublicacionRepositoryImpl();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {return BlocPublicacionesBloc(publicacionRepository)..add(FetchPublicacionWithType(Constant.nowPlaying));},
      child: Scaffold(
        appBar: const HomeAppBar(),
        body: _createPublics(context),
      ),
    );
  }
}

Widget _createPublics(BuildContext context) {
  return BlocBuilder<BlocPublicacionesBloc, BlocPublicacionesState>(
    builder: (context, state) {
      if (state is BlocPublicacionesInitial) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is PublicacionFetchError) {
        return ErrorPage(
          message: state.message,
          retry: () {
            context
                .watch<BlocPublicacionesBloc>()
                .add(FetchPublicacionWithType(Constant.nowPlaying));
          },
        );
      } else if (state is PublicacionesFetched) {
        return _createPopularView(context, state.movies);
      } else {
        return const Text('Not support');
      }
    },
  );
}

Widget _createPopularView(BuildContext context, List<PublicacionData> movies) {
  return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return _post(context, movies[index]);
            },
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            scrollDirection: Axis.vertical,
            separatorBuilder: (context, index) => const VerticalDivider(
              color: Colors.transparent,
              width: 6.0,
            ),
            itemCount: movies.length,
          ),
        );

}

  Widget _post (BuildContext context, PublicacionData data){
    return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(.3)))),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          leading:  ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: CachedNetworkImage(
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                imageUrl: data.user.avatar.replaceAll(
                    "http://localhost:8080", "http://10.0.2.2:8080"),
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
            ),
          title: Text(
            data.user.nick,
            style: TextStyle(
                color: Colors.black.withOpacity(.8),
                fontWeight: FontWeight.w400,
                fontSize: 21),
          ),
          trailing: const Icon(Icons.more_vert),
        ),
        InstaLikeButton(
          image:  NetworkImage(data.file.toString().replaceFirst('localhost', '10.0.2.2')),
          onChanged: () {},
          icon: Icons.favorite,
          iconSize: 80,
          iconColor: Colors.red,
          curve: Curves.fastLinearToSlowEaseIn,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: const <Widget>[
                  Icon(
                    Icons.favorite_border,
                    size: 31,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Icon(Icons.comment_sharp, size: 31),
                  SizedBox(
                    width: 12,
                  ),
                  Icon(Icons.send, size: 31),
                ],
              ),
              const Icon(Icons.bookmark_border, size: 31)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Text(
            'liked by you and 299 others',
            style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(.8)),
          ),
        )
      ],
    ),
  );
  }
