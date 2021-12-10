import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskflow/database/custom_list_database.dart';
import 'package:taskflow/database/task_database.dart';
import 'package:taskflow/database/user_database.dart';
import 'package:taskflow/model/custom_list_model.dart';
import 'package:taskflow/model/task_model.dart';
import 'package:taskflow/model/user_model.dart';
import 'package:taskflow/notification_service.dart';
import 'package:date_format/date_format.dart';

class AddTaskScreen extends StatefulWidget {
  late Function refreshTasks;
  AddTaskScreen({required this.refreshTasks});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  late List<Task> tasks;
  late List<list> lists = [];
  late List<User> users = [];
  bool isLoading = false;
  late String selectedList = '';
  int selectedIndex = 0;
  late double _height;
  late double _width;
  String _setDate = '';
  String _setTime = '';
  late String _hour, _minute, _time;
  late String dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();

    super.initState();

    NotificationApi.init(initSheduled: true);
    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.tasks = await TaskDatabase.instance.readAllNotes();
    this.lists = await ListDatabase.instance.readAllNotes();
    this.users = await UserDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Create task',
              onPressed: () {
                if (nameController.text.length == 0) {
                } else {
                  var task = Task(
                    taskName: nameController.text,
                    note: noteController.text,
                    listName: lists.length == 0
                        ? 'My Day'
                        : lists[selectedIndex].listName,
                    isDeleted: false,
                    isCompleted: false,
                    isImportant: false,
                    dueDate: _dateController.text.toString(),
                    dueTime: _timeController.text.toString(),
                  );
                  TaskDatabase.instance.create(task);
                  widget.refreshTasks();
                  Navigator.pop(context);
                  if (users[0].isReminderOn) {
                    NotificationApi.showSheduleNotification(
                      sheduledDate: DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute), 
                          title: nameController.text, 
                          body: 'You have a due task'
                          );
                  } else {
                    
                  }
                }
              },
              icon: Icon(Icons.done))
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.0,
        brightness: Brightness.dark,
        backgroundColor: Colors.blue[700],
        title: Text('Add New Task', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 26.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 75.0,
                width: MediaQuery.of(context).size.width - 40.0,
                child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  maxLength: 60,
                  controller: nameController,
                  onFieldSubmitted: (value) {
                    nameController.text = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Task Title',
                    hintStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                        width: 2.0,
                      ),
                    ),
                    counterStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(
                      Icons.title,
                      size: 24,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 75.0,
                width: MediaQuery.of(context).size.width - 40.0,
                child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  maxLength: 60,
                  controller: noteController,
                  onFieldSubmitted: (value) {
                    noteController.text = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Note',
                    hintStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                        width: 2.0,
                      ),
                    ),
                    counterStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(
                      Icons.note,
                      size: 24,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Remind Date',
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.black, fontSize: 24.0),
          ),
          GestureDetector(
            onTap: () {
              _selectDate(context);
            },
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width - 50.0,
              child: TextFormField(
                style: TextStyle(fontSize: 25.0, color: Colors.black),
                textAlign: TextAlign.center,
                enabled: false,
                keyboardType: TextInputType.text,
                controller: _dateController,
                onChanged: (String val) {
                  _setDate = val;
                },
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Remind Time',
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.black, fontSize: 24.0),
          ),
          GestureDetector(
            onTap: () {
              _selectTime(context);
            },
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width - 50.0,
              child: TextFormField(
                style: TextStyle(fontSize: 25.0, color: Colors.black),
                textAlign: TextAlign.center,
                enabled: false,
                keyboardType: TextInputType.text,
                controller: _timeController,
                onChanged: (String val) {
                  _setTime = val;
                },
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'List Name',
            style: TextStyle(color: Colors.black, fontSize: 24.0),
          ),
          Expanded(
            child: Container(
              height: 50.0,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: lists.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20.0,
                          ),
                          Container(
                            height: 50.0,
                            width: 100.0,
                            child: Center(
                                child: Text(
                              lists[index].listName,
                              style: TextStyle(
                                  color: selectedIndex == index ? Colors.white : Colors.black, fontSize: 16.0),
                            )),
                            decoration: BoxDecoration(
                                color: selectedIndex == index
                                    ? Colors.red
                                    : Colors.white,
                                border: selectedIndex == index
                                    ? Border.all(color: Colors.red)
                                    : Border.all(color: Colors.red),
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
          Container(
            height: 70.0,
          ),
          // Flexible(
          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child: GestureDetector(
          //       onTap: () {
          //         if (nameController.text.length == 0) {
          //         } else {
          //           var task = Task(
          //             taskName: nameController.text,
          //             note: noteController.text,
          //             listName: lists.length == 0 ? 'My Day' : lists[selectedIndex].listName,
          //             isDeleted: false,
          //             isCompleted: false,
          //             isImportant: false,
          //             dueDate: _dateController.text.toString(),
          //             dueTime: _timeController.text.toString(),
          //           );
          //           TaskDatabase.instance.create(task);
          //           widget.refreshTasks();
          //           Navigator.pop(context);
          //         }
          //       },
          //       child: Container(
          //         child: Center(
          //           child: Text(
          //             'Create Task',
          //             style: TextStyle(
          //                 color: Colors.black,
          //                 fontSize: 20.0,
          //                 fontWeight: FontWeight.bold),
          //           ),
          //         ),
          //         height: 50.0,
          //         width: MediaQuery.of(context).size.width - 50.0,
          //         decoration: BoxDecoration(
          //             color: Colors.red,
          //             borderRadius: BorderRadius.all(Radius.circular(30.0))),
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 30.0,
          )
        ],
      ),
    );
  }
}
