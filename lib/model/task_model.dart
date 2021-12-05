final String tableNotes = 'tasks';

class TaskFields {
  static final List<String> values = [
    /// Add all fields
    id, taskName, note, isCompleted, isDeleted, dueDate, dueTime, listName
  ];

  static final String id = '_id';
  static final String taskName = 'taskName';
  static final String note = 'note';
  static final String isCompleted = 'isCompleted';
  static final String isDeleted = 'isDeleted';
  static final String isImportant = 'isImportant';
  static final String dueDate = 'dueDate';
  static final String dueTime = 'dueTime';
  static final String listName = 'listName';
}

class Task {
  final int? id;
  late String taskName;
  late String? note;
  late bool isCompleted;
  late bool isDeleted;
  late bool isImportant;
  late String dueDate;
  late String dueTime;
  late String listName; 

  Task(
      {this.id,
      required this.taskName,
      required this.isCompleted,
      this.note,
      required this.isDeleted, 
      required this.isImportant,
      required this.dueDate,
      required this.dueTime,
      required this.listName,
      });

  Task copy({
    int? id,
    String? taskName,
    String? note,
    bool? isCompleted,
    bool? isDeleted,
    bool? isImportant,
    String? dueTime,
    String? dueDate,
    String? listName,
  }) =>
      Task(
        id: id ?? this.id,
        taskName: taskName ?? this.taskName,
        note: note ?? this.note,
        isCompleted: isCompleted ?? this.isCompleted,
        isDeleted: isDeleted ?? this.isDeleted,
        isImportant: isImportant ?? this.isImportant,
        dueDate: dueDate ?? this.dueDate,
        dueTime: dueTime ?? this.dueTime,
        listName: listName ?? this.listName,
      );

  static Task fromJson(Map<String, Object?> json) => Task(
        id: json[TaskFields.id] as int?,
        taskName: json[TaskFields.taskName] as String,
        note: json[TaskFields.note] as String,
        isCompleted: json[TaskFields.isCompleted] == 1,
        isDeleted: json[TaskFields.isDeleted] == 1,
        isImportant: json[TaskFields.isImportant] == 1,
        dueDate: json[TaskFields.dueDate] as String,
        dueTime: json[TaskFields.dueTime] as String,
        listName: json[TaskFields.listName] as String,
      );

  Map<String, Object?> toJson() => {
        TaskFields.id: id,
        TaskFields.taskName: taskName,
        TaskFields.note: note,
        TaskFields.isCompleted: isCompleted ? 1 : 0,
        TaskFields.isDeleted: isDeleted ? 1 : 0,
        TaskFields.isImportant: isImportant ? 1 : 0,
        TaskFields.dueDate: dueDate,
        TaskFields.dueTime: dueTime,
        TaskFields.listName: listName,
      };
}
