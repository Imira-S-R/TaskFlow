import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskflow/database/task_database.dart';
import 'package:taskflow/model/task_model.dart';
import 'package:taskflow/screens/edit_task_screen.dart';

class TaskViewerScreen extends StatefulWidget {
  late int? id;
  late bool? isCompleted;
  late bool? isImportant;
  late bool? isDeleted;
  late String? taskName;
  late String? taskNote;
  late String? dueDate;
  late String? dueTime;
  late String? listName;
  late Function refreshTasks;

  TaskViewerScreen({
    required this.id,
    required this.isCompleted,
    required this.isImportant,
    required this.isDeleted,
    required this.taskName,
    required this.taskNote,
    required this.dueDate,
    required this.dueTime,
    required this.listName,
    required this.refreshTasks,
  });

  @override
  _TaskvieweVStateScreen createState() => _TaskvieweVStateScreen();
}

class _TaskvieweVStateScreen extends State<TaskViewerScreen> {
  late final dueDate = DateTime.parse(widget.dueDate.toString());
  late final dueTime = TimeOfDay(
      hour: int.parse(widget.dueTime!.split(":")[0]),
      minute: int.parse(widget.dueTime!.split(":")[1]));

  late List<Task> tasks = [];
  bool isLoading = false;

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
      backgroundColor: Colors.blue[700],
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0.0,
        actions: [
          IconButton(
            tooltip: 'Edit task',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditTaskScreen(
                          id: widget.id!,
                          taskName: widget.taskName,
                          taskNote: widget.taskNote,
                          isCompleted: widget.isCompleted,
                          isDeleted: widget.isDeleted,
                          isImportant: widget.isImportant,
                          dueDate: widget.dueDate!,
                          dueTime: widget.dueTime,
                          listName: widget.listName,
                          refreshTasks: refreshNotes,
                        )));
              },
              icon: Icon(Icons.edit)),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
            tooltip: 'Delete Task',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    title: new Text(
                      "Are you sure ?",
                      style: TextStyle(color: Colors.white),
                    ),
                    content: new Text(
                      "Do you want to delete this task",
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: <Widget>[
                      new TextButton(
                        child: new Text(
                          "Yes",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          TaskDatabase.instance.delete(widget.id!);
                          widget.refreshTasks();
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
          )
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blue[700],
        title: Text(
          'Tasks',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Title',
              style: TextStyle(color: Colors.white70, fontSize: 16.0),
            ),
            Flexible(
              child: Text(
                widget.taskName!,
                maxLines: 6,
                style: TextStyle(
                    color: widget.isCompleted! ? Colors.white70 : Colors.white,
                    fontSize: 22.0,
                    decoration: widget.isCompleted!
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Task Note',
              style: TextStyle(color: Colors.white70, fontSize: 16.0),
            ),
            Text(
              widget.taskNote!.length == 0 ? 'No Note Added' : widget.taskNote!,
              style: TextStyle(color: Colors.white, fontSize: 22.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Due Date',
              style: TextStyle(color: Colors.white70, fontSize: 16.0),
            ),
            Text(
              widget.dueDate!,
              style: TextStyle(color: Colors.white, fontSize: 22.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Due Time',
              style: TextStyle(color: Colors.white70, fontSize: 16.0),
            ),
            Text(
              widget.dueTime!,
              style: TextStyle(color: Colors.white, fontSize: 22.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'List Name',
              style: TextStyle(color: Colors.white70, fontSize: 16.0),
            ),
            Text(
              widget.listName!,
              style: TextStyle(color: Colors.white, fontSize: 22.0),
            ),
          ],
        ),
      ),
    );
  }
}
