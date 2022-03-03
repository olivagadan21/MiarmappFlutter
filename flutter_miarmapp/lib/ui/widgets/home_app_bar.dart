import 'package:flutter/material.dart';
import 'package:flutter_miarmapp/ui/screens/create_publicacion_screen.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
          flex: 1,
          child: Image.asset(
            'assets/images/logo_miarmapp.png',
            width: 100,
          ),
        ),
        Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PublicacionScreen()),
                        );
                      },
                      icon: const Icon(Icons.add_box_outlined)),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.send),
                )
              ],
            ))
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
