import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskflow/model/custom_list_model.dart';


class ListDatabase {
  static final ListDatabase instance = ListDatabase._init();

  static Database? _database;

  ListDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('list.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableNotes ( 
  ${listFields.id} $idType, 
  ${listFields.listName} $textType,
  ${listFields.color} $textType
  )
''');
  }

  Future<list> create(list list) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableNotes, list.toJson());
    return list.copy(id: id);
  }

  Future<list> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: listFields.values,
      where: '${listFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return list.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<list>> readAllNotes() async {
    final db = await instance.database;

    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableNotes);

    return result.map((json) => list.fromJson(json)).toList();
  }

  Future<int> update(list list) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      list.toJson(),
      where: '${listFields.id} = ?',
      whereArgs: [list.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${listFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
