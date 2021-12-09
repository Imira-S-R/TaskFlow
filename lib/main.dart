import 'package:flutter/material.dart';
import 'package:taskflow/database/user_database.dart';
import 'package:taskflow/model/user_model.dart';
import 'package:taskflow/screens/get_started_screen.dart';
import 'package:taskflow/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<User> users = [];
  bool isLoading = false;


  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.users = await UserDatabase.instance.readAllNotes();

    setState(() => isLoading = true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      home: users.length == 0 ? GetStartedScreen() : Home(),
    );
  }
}