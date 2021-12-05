final String tableNotes = 'list';

// ignore: camel_case_types
class listFields {
  static final List<String> values = [
    /// Add all fields
    id, listName, color
  ];

  static final String id = '_id';
  static final String listName = 'listName';
  static final String color = 'color';
}

class list {
  final int? id;
  final String listName;
  final String? color;


  list(
      {this.id,
      required this.listName,
      required this.color,
      });

  list copy({
    int? id,
    String? listName,
    String? color,
  }) =>
      list(
        id: id ?? this.id,
        listName: listName ?? this.listName,
        color: color ?? this.color,
      );

  static list fromJson(Map<String, Object?> json) => list(
        id: json[listFields.id] as int?,
        listName: json[listFields.listName] as String,
        color: json[listFields.color] as String,
      );

  Map<String, Object?> toJson() => {
        listFields.id: id,
        listFields.listName: listName,
        listFields.color: color,
      };
}
