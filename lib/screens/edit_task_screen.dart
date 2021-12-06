import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskflow/database/custom_list_database.dart';
import 'package:taskflow/database/task_database.dart';
import 'package:taskflow/model/custom_list_model.dart';
import 'package:taskflow/model/task_model.dart';

class EditTaskScreen extends StatefulWidget {
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

  EditTaskScreen({
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
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  late List<Task> tasks;
  late List<list> lists = [];
  late int selectedIndex;
  bool isLoading = false;
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
    super.initState();

    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.tasks = await TaskDatabase.instance.readAllNotes();
    this.lists = await ListDatabase.instance.readAllNotes();
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
      backgroundColor: Color(0xff20A39E),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                if (nameController.text == '' && noteController.text == '') {
                  TaskDatabase.instance.update(Task(
                    id: widget.id!,
                    taskName: widget.taskName!,
                    note: widget.taskNote!,
                    dueTime: widget.dueTime!,
                    dueDate: widget.dueDate!,
                    isCompleted: widget.isCompleted!,
                    isDeleted: widget.isDeleted!,
                    isImportant: widget.isImportant!,
                    listName: widget.listName!,
                  ));
                  widget.refreshTasks();
                  Navigator.pop(context);
                } else if (nameController.text == '') {
                  TaskDatabase.instance.update(Task(
                    id: widget.id!,
                    taskName: widget.taskName!,
                    note: noteController.text,
                    dueTime: widget.dueTime!,
                    dueDate: widget.dueDate!,
                    isCompleted: widget.isCompleted!,
                    isDeleted: widget.isDeleted!,
                    isImportant: widget.isImportant!,
                    listName: widget.listName!,
                  ));
                  widget.refreshTasks();
                  Navigator.pop(context);
                } else if (noteController.text == '') {
                   TaskDatabase.instance.update(Task(
                    id: widget.id!,
                    taskName: nameController.text,
                    note: noteController.text,
                    dueTime: widget.dueTime!,
                    dueDate: widget.dueDate!,
                    isCompleted: widget.isCompleted!,
                    isDeleted: widget.isDeleted!,
                    isImportant: widget.isImportant!,
                    listName: widget.listName!,
                  ));
                  widget.refreshTasks();
                  Navigator.pop(context);
                }
                widget.refreshTasks();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              icon: Icon(Icons.done, color: Colors.white))
        ],
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white)),
        backgroundColor: Color(0xff20A39E),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 75.0,
                width: MediaQuery.of(context).size.width - 40.0,
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  maxLength: 60,
                  initialValue: widget.taskName,
                  onChanged: (value) {
                    nameController.text = value;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.white10,
                        width: 2.0,
                      ),
                    ),
                    counterStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.title_outlined,
                      size: 24,
                      color: Colors.white,
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
                  style: TextStyle(color: Colors.white),
                  maxLength: 60,
                  initialValue: widget.taskNote,
                  onChanged: (value) {
                    noteController.text = value;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.white10,
                        width: 2.0,
                      ),
                    ),
                    counterStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.note_outlined,
                      size: 24,
                      color: Colors.white,
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
          Text(
            'Remind Date',
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          GestureDetector(
            onTap: () {
              _selectDate(context);
            },
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width - 50.0,
              child: TextFormField(
                style: TextStyle(fontSize: 25.0, color: Colors.white),
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
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          GestureDetector(
            onTap: () {
              _selectTime(context);
            },
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width - 50.0,
              child: TextFormField(
                style: TextStyle(fontSize: 25.0, color: Colors.white),
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
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
