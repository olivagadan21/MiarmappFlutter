import 'package:flutter/material.dart';

import 'widgets/home_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: post('assets/images/foto.png', "oliva.gadan21"),
          ),
        ],
      ),
    );
  }
}

Widget post(String image, name) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(.3)))),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          leading: const CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage('assets/images/foto.png'),
          ),
          title: Text(
            name,
            style: TextStyle(
                color: Colors.black.withOpacity(.8),
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          trailing: const Icon(Icons.more_vert),
        ),
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: Image.asset(
            image,
            width: double.infinity,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  Row(
                    children: const <Widget>[
                      Icon(Icons.favorite_border, size: 25),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Icon(Icons.mode_comment_outlined, size: 25),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Icon(Icons.send_outlined, size: 25),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("168 Me gustas"),
                  ),
                ],
              ),
              const Icon(Icons.bookmark_border, size: 25)
            ],
          ),
        ),
      ],
    ),
  );
}
