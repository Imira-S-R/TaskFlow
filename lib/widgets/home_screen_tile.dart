// Function to create the list tiles that have to displayed on the home screen
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomeScreenTile extends StatefulWidget {
  IconData? icon;
  String text;
  Widget route;

  HomeScreenTile({required this.icon, required this.text, required this.route});

  @override
  _HomeScreenTileState createState() => _HomeScreenTileState();
}

class _HomeScreenTileState extends State<HomeScreenTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => widget.route));
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 40.0,
            height: 50.0,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Row(
              children: [
                SizedBox(
                  width: 10.0,
                ),
                Icon(
                  widget.icon,
                  color: Colors.black,
                  size: 26.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  widget.text,
                  style: (TextStyle(color: Colors.black, fontSize: 20.0)),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
