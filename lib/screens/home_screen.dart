import 'package:flutter/material.dart';
import 'package:taskflow/database/custom_list_database.dart';
import 'package:taskflow/model/custom_list_model.dart';
import 'package:taskflow/screens/add_custom_list_screen.dart';
import 'package:taskflow/screens/all_tasks_screen.dart';
import 'package:taskflow/screens/custom_list_screen.dart';
import 'package:taskflow/screens/important_screen.dart';
import 'package:taskflow/screens/my_day_screen.dart';
import 'package:taskflow/widgets/home_screen_tile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<list> lists = [];
  bool isLoading = false;
  String status = '';

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.lists = await ListDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xffF7F7F7),
        title: Text(
          'TaskFlow',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              tooltip: 'Settings',
              onPressed: () {},
              icon: Icon(
                Icons.settings_rounded,
                color: Colors.black,
              ))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10.0,
          ),
          HomeScreenTile(
            icon: Icons.home_outlined,
            text: 'My Day',
            route: MyDay(),
          ),
          
          Container(
            width: MediaQuery.of(context).size.width - 50.0,
            child: Divider(
              color: Colors.black87,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          HomeScreenTile(
              icon: Icons.add,
              text: 'Add Custom List',
              route: AddCustomList(
                refreshLists: refreshNotes,
              )),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
              child: Container(
            child: ListView.builder(
              itemCount: lists.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CustomListScreen(
                                  listName: lists[index].listName,
                                  color: lists[index].color,
                                  refreshLists: refreshNotes,
                                  id: lists[index].id
                                )));
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width - 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  lists[index].listName,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20.0),
                                ),
                              ),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 10.0,
                    )
                  ],
                );
              },
            ),
          )),
        ],
      ),
    );
  }
}
