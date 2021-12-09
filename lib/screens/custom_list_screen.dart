import 'package:flutter/material.dart';
import 'package:taskflow/database/custom_list_database.dart';
import 'package:taskflow/database/task_database.dart';
import 'package:taskflow/model/task_model.dart';
import 'package:taskflow/screens/add_task_screen.dart';
import 'package:taskflow/screens/task_viewer_screen.dart';

class CustomListScreen extends StatefulWidget {
  late String? listName;
  late String? color;
  late int? id;
  Function refreshLists;

  CustomListScreen(
      {required this.listName,
      required this.color,
      required this.refreshLists,
      required this.id});

  @override
  _CustomListScreenState createState() => _CustomListScreenState();
}

class _CustomListScreenState extends State<CustomListScreen> {
  bool isLoading = false;
  late List<Task> tasks = [];
  late List<Task> filtredTaskList = [];

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.tasks = await TaskDatabase.instance.readAllNotes();
    this.filtredTaskList =
        await TaskDatabase.instance.readSpecificTasks(widget.listName);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add new task',
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddTaskScreen(
                      refreshTasks: refreshNotes,
                    )));
          },
          backgroundColor: Color(0xff20A39E),
          child: Icon(
            Icons.add,
            size: 30.0,
          ),
        ),
        backgroundColor: Color(int.parse(widget.color!)),
        appBar: AppBar(
          brightness: Brightness.dark,
          elevation: 0.0,
          backgroundColor: Color(int.parse(widget.color!)),
          title: Text(widget.listName!),
          actions: [
            IconButton(
                tooltip: 'Delete list',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Color(int.parse(widget.color!)),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        title: new Text(
                          "Are you sure ?",
                          style: TextStyle(color: Colors.white),
                        ),
                        content: new Text(
                          "Do you want to delete this entire list?",
                          style: TextStyle(color: Colors.white),
                        ),
                        actions: <Widget>[
                          new TextButton(
                            child: new Text(
                              "Yes",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              ListDatabase.instance.delete(widget.id!);
                              widget.refreshLists();
                              for (var task in filtredTaskList) {
                                setState(() {
                                  TaskDatabase.instance.delete(task.id!);
                                });
                              }
                              Navigator.of(context).pop();
                              Navigator.pop(context);
                            },
                          ),
                          new TextButton(
                            child: new Text(
                              "No",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.delete_outline, color: Colors.white))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: filtredTaskList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => TaskViewerScreen(
                                          id: filtredTaskList[index].id!,
                                          taskName:
                                              filtredTaskList[index].taskName,
                                          taskNote: filtredTaskList[index].note,
                                          isCompleted: filtredTaskList[index]
                                              .isCompleted,
                                          isDeleted:
                                              filtredTaskList[index].isDeleted,
                                          isImportant: filtredTaskList[index]
                                              .isImportant,
                                          dueDate:
                                              filtredTaskList[index].dueDate,
                                          dueTime:
                                              filtredTaskList[index].dueTime,
                                          listName:
                                              filtredTaskList[index].listName,
                                          refreshTasks: refreshNotes,
                                        )));
                              },
                              child: Container(
                                height: 60.0,
                                width: MediaQuery.of(context).size.width - 60.0,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            var task = Task(
                                                id: filtredTaskList[index].id,
                                                taskName: filtredTaskList[index]
                                                    .taskName,
                                                note:
                                                    filtredTaskList[index].note,
                                                listName: filtredTaskList[index]
                                                    .listName,
                                                isCompleted:
                                                    !filtredTaskList[index]
                                                        .isCompleted,
                                                isDeleted: false,
                                                isImportant:
                                                    filtredTaskList[index]
                                                        .isImportant,
                                                dueDate: filtredTaskList[index]
                                                    .dueDate,
                                                dueTime: filtredTaskList[index]
                                                    .dueTime);
                                            TaskDatabase.instance.update(task);
                                            refreshNotes();
                                            print('Updated succesfully');
                                          });
                                        },
                                        icon: Icon(
                                          filtredTaskList[index].isCompleted
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          size: 26.0,
                                        )),
                                    Flexible(
                                        child: Text(
                                      filtredTaskList[index].taskName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          decoration:
                                              filtredTaskList[index].isCompleted
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                          color:
                                              filtredTaskList[index].isCompleted
                                                  ? Colors.black54
                                                  : Colors.black,
                                          fontSize: 19.0),
                                    )),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }
}
