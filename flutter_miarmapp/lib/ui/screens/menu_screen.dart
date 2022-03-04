import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_miarmapp/bloc/bloc_ver_perfil/bloc/user_with_post_bloc.dart';
import 'package:flutter_miarmapp/models/user_with_post.dart';
import 'package:flutter_miarmapp/repository/user_with_post_repository/user_with_post_repository.dart';
import 'package:flutter_miarmapp/repository/user_with_post_repository/user_with_post_repository_impl.dart';
import 'package:flutter_miarmapp/ui/widgets/error_page.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late UserPostRepository userRepository;

  @override
  void initState() {
    userRepository = UserPostRepositoryImpl();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _currentIndex = 0;

  List<Widget> pages = [
    const HomeScreen(),
    const SearchScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return UserWithPostBloc(userRepository)..add(const FetchUserWithType());
      },
      child: Scaffold(
          body: pages[_currentIndex],
          bottomNavigationBar: _createPublics(context)),
    );
  }

  Widget _createPublics(BuildContext context) {
    return BlocBuilder<UserWithPostBloc, UserWithPostState>(
      builder: (context, state) {
        if (state is UserWithPostInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserFetchedError) {
          return ErrorPage(
            message: state.message,
            retry: () {
              context.watch<UserWithPostBloc>().add(const FetchUserWithType());
            },
          );
        } else if (state is UsersFetched) {
          return _buildBottomBar(context, state.users);
        } else {
          return const Text('Not support');
        }
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, UserData user) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(
          top: BorderSide(
            color: Color(0xfff1f1f1),
            width: 1.0,
          ),
        )),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: Icon(Icons.home,
                  color: _currentIndex == 0
                      ? Colors.black
                      : const Color(0xff999999)),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            GestureDetector(
              child: Icon(Icons.search,
                  color: _currentIndex == 1
                      ? Colors.black
                      : const Color(0xff999999)),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: _currentIndex == 2
                              ? Colors.black
                              : Colors.transparent,
                          width: 1),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(user.avatar
                              .toString()
                              .replaceFirst('localhost', '10.0.2.2')))),
                ))
          ],
        ));
  }
}
