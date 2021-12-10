import 'package:flutter/material.dart';
import 'package:taskflow/database/task_database.dart';
import 'package:taskflow/model/task_model.dart';
import 'package:taskflow/screens/add_task_screen.dart';
import 'package:taskflow/screens/task_viewer_screen.dart';

class MyDay extends StatefulWidget {
  const MyDay({Key? key}) : super(key: key);

  @override
  _MyDayState createState() => _MyDayState();
}

class _MyDayState extends State<MyDay> {
  late List<Task> tasks = [];
  bool isLoading = false;
  String status = '';
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.tasks = await TaskDatabase.instance.readAllNotes();

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
        backgroundColor: Colors.blue[700],
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30.0,
        ),
      ),
      backgroundColor: Color(0xff788BFF),
      appBar: AppBar(
        brightness: Brightness.dark,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.0,
        backgroundColor: Color(0xff788BFF),
        title: Text(
          'My Day',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: Container(
              child: ListView.builder(
                itemCount: tasks.length,
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
                                        id: tasks[index].id!,
                                        taskName: tasks[index].taskName,
                                        taskNote: tasks[index].note,
                                        isCompleted: tasks[index].isCompleted,
                                        isDeleted: tasks[index].isDeleted,
                                        isImportant: tasks[index].isImportant,
                                        dueDate: tasks[index].dueDate,
                                        dueTime: tasks[index].dueTime,
                                        listName: tasks[index].listName,
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
                                              id: tasks[index].id,
                                              taskName: tasks[index].taskName,
                                              note: tasks[index].note,
                                              listName: tasks[index].listName,
                                              isCompleted:
                                                  !tasks[index].isCompleted,
                                              isDeleted: false,
                                              isImportant:
                                                  tasks[index].isImportant,
                                              dueDate: tasks[index].dueDate,
                                              dueTime: tasks[index].dueTime);
                                          TaskDatabase.instance.update(task);
                                          refreshNotes();
                                          print('Updated succesfully');
                                        });
                                      },
                                      icon: Icon(
                                        tasks[index].isCompleted
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        size: 26.0,
                                      )),
                                  Flexible(
                                      child: Text(
                                    tasks[index].taskName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        decoration: tasks[index].isCompleted
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        color: tasks[index].isCompleted
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
      ),
    );
  }
}


// return Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.of(context).push(MaterialPageRoute(
//                                   builder: (context) => TaskViewerScreen(
//                                         id: tasks[index].id!,
//                                         taskName: tasks[index].taskName,
//                                         taskNote: tasks[index].note,
//                                         isCompleted: tasks[index].isCompleted,
//                                         isDeleted: tasks[index].isDeleted,
//                                         isImportant: tasks[index].isImportant,
//                                         dueDate: tasks[index].dueDate,
//                                         dueTime: tasks[index].dueTime,
//                                         listName: tasks[index].listName,
//                                         refreshTasks: refreshNotes,
//                                       )));
//                             },
//                             child: Container(
//                               height: 50.0,
//                               width: MediaQuery.of(context).size.width - 50.0,
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(10.0))),
//                               child: Row(
//                                 children: [
//                                   IconButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         var task = Task(
//                                             id: tasks[index].id,
//                                             taskName: tasks[index].taskName,
//                                             note: tasks[index].note,
//                                             listName: tasks[index].listName,
//                                             isCompleted:
//                                                 !tasks[index].isCompleted,
//                                             isDeleted: false,
//                                             isImportant:
//                                                 tasks[index].isImportant,
//                                             dueDate: tasks[index].dueDate,
//                                             dueTime: tasks[index].dueTime);
//                                         TaskDatabase.instance.update(task);
//                                         refreshNotes();
//                                         print('Updated succesfully');
//                                       });
//                                     },
//                                     icon: Icon(tasks[index].isCompleted
//                                         ? Icons.check_box
//                                         : Icons.check_box_outline_blank),
//                                     padding: EdgeInsets.zero,
//                                   ),
//                                   Flexible(
//                                     child: Text(
//                                       tasks[index].taskName,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                           decoration: tasks[index].isCompleted
//                                               ? TextDecoration.lineThrough
//                                               : TextDecoration.none,
//                                           color: tasks[index].isCompleted
//                                               ? Colors.black54
//                                               : Colors.black,
//                                           fontSize: 20.0),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10.0,
//                       )
//                     ],
//                   );