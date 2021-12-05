import 'package:flutter/material.dart';

class ImportantScreen extends StatefulWidget {
  const ImportantScreen({Key? key}) : super(key: key);

  @override
  _ImportantState createState() => _ImportantState();
}

class _ImportantState extends State<ImportantScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0.0,
         leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Important', style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
