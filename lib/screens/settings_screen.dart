import 'package:flutter/material.dart';
import 'package:taskflow/database/user_database.dart';
import 'package:taskflow/model/user_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool sendReminders = true;
  late List<User> users = [];

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  Future refreshNotes() async {
    this.users = await UserDatabase.instance.readAllNotes();
    sendReminders = users[0].isReminderOn;
  }

  void toggleSwitch(bool value) {
    if (sendReminders == false) {
      setState(() {
        sendReminders = true;
        UserDatabase.instance
            .update(User(id: users[0].id, isReminderOn: sendReminders));
        print('Updated succesfully: ${sendReminders.toString()}');
      });
    } else {
      setState(() {
        sendReminders = false;
        UserDatabase.instance
            .update(User(id: users[0].id, isReminderOn: sendReminders));
        print('Updated succesfully: ${sendReminders.toString()}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        brightness: Brightness.dark,
        backgroundColor: Colors.blue[700],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0,),
            Text(
              'General',
              style: TextStyle(color: Colors.black, fontSize: 15.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Text(
                  'Send Reminders',
                  style: TextStyle(color: Colors.black, fontSize: 22.0),
                ),
                Spacer(),
                SizedBox(
                  width: 10.0,
                ),
                // Switch(
                //   onChanged: toggleSwitch,
                //   value: sendReminders,
                //   activeColor: Colors.green,
                //   activeTrackColor: Colors.green[600],
                //   inactiveThumbColor: Colors.redAccent,
                //   inactiveTrackColor: Colors.red,
                // ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      UserDatabase.instance
                          .update(User(id: users[0].id, isReminderOn: true));
                    });
                  },
                  child: Text('Yes'),
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.red, primary: Colors.white),
                ),
                SizedBox(
                  width: 6.0,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      UserDatabase.instance
                          .update(User(id: users[0].id, isReminderOn: false));
                    });
                  },
                  child: Text('No'),
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.red, primary: Colors.white),
                ),
              ],
            ),
            Text(
              'Version',
              style: TextStyle(color: Colors.black, fontSize: 15.0),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Version: 1.0.0',
              style: TextStyle(color: Colors.black, fontSize: 22.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'About',
              style: TextStyle(color: Colors.black, fontSize: 15.0),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Made By Imira.',
              style: TextStyle(color: Colors.black, fontSize: 22.0),
            ),
          ],
        ),
      ),
    );
  }
}
