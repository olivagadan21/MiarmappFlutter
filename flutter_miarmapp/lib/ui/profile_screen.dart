import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "oliva.gadan21",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
        ),
        actions: const [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.menu,
                  size: 30,
                  color: Colors.black,
                ),
              ))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/foto.png')),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: const [
                                TextButton(
                                  onPressed: null,
                                  child: Text(
                                    "1",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                Text("post"),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "421",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                const Text(
                                  "followers",
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {},
                                    child: const Text("637",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black))),
                                const Text("following"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 8),
                      child: Text("Daniel Oliva García"),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 8, bottom: 15),
                      child: Text(
                        "Desarrollo de Aplicaciones Multiplataforma",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
                Container(
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    width: 320,
                    child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Edit Profile",
                          style: TextStyle(color: Colors.black),
                        )))
              ],
            ),
            Column(
              children: [
                const Divider(
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.table_chart_outlined)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.person_search)),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/foto.png')),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
