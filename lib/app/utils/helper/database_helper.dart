import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tasks/app/controller/formatting_date.dart';
import 'package:tasks/app/model/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        date TEXT,
        startTime TEXT,
        endTime TEXT,
        notification INTEGER
      )
    ''');
  }

  Future<int> insertTask(Task task) async {
    Database db = await database;
    return await db.insert('tasks', task.toJson());
  }

  Future<List<Task>> getTasks() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return maps.map((map) => Task.fromJson(map)).toList();
  }

  // Updated method to get tasks for a specific day
  Future<List<Task>> getTasksForDay(DateTime day) async {
    Database db = await database;
    String formattedDate = FormattingDate().formatDate(day);

    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'date = ?',
      whereArgs: [formattedDate],
    );

    return maps.map((map) => Task.fromJson(map)).toList();
  }

  Future<int> deleteTask(int id) async {
    Database db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    Database db = await database;
    db.close();
  }

}
