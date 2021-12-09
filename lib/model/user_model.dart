final String tableNotes = 'tasks';

class UserFields {
  static final List<String> values = [
    /// Add all fields
    id, isReminderOn
  ];

  static final String id = '_id';
  static final String isReminderOn = 'isReminderOn';
}

class User {
  final int? id;
  late bool isReminderOn; 

  User(
      {this.id,
      required this.isReminderOn,
      });

  User copy({
    int? id,
    bool? isReminderOn,

  }) =>
      User(
        id: id ?? this.id,
        isReminderOn: isReminderOn ?? this.isReminderOn,
      );

  static User fromJson(Map<String, Object?> json) => User(
        id: json[UserFields.id] as int?,
        isReminderOn: json[UserFields.isReminderOn] == 1,
      );

  Map<String, Object?> toJson() => {
        UserFields.id: id,
        UserFields.isReminderOn: isReminderOn ? 1 : 0,
      };
}
