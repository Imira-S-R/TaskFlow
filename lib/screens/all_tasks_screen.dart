import 'package:flutter/material.dart';

class AllTaskScreen extends StatefulWidget {
  const AllTaskScreen({Key? key}) : super(key: key);

  @override
  _AllTaskScreenState createState() => _AllTaskScreenState();
}

class _AllTaskScreenState extends State<AllTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff00C2D1),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xff00C2D1),
        title: Text(
          'All Tasks',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
