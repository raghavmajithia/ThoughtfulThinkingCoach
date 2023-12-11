/*import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Database {
  static final _databaseName = "Reflections.db";
  static final _databaseVersion = 1;

  static final table = 'responses';

  static final columnId = '_id';
  static final columnQuestion = 'question';
  static final columnResponse = 'response';

  // make this a singleton class.
  Database._privateConstructor();
  static final Database instance = Database._privateConstructor();

  // only have a single app-wide reference to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the private database
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $table (
          $columnId INTEGER PRIMARY KEY,
          $columnQuestion TEXT NOT NULL,
          $columnResponse TEXT NOT NULL
        )
        ''');
  }

  Future<int> insert(String question, String response) async {
    Database db = await instance.database;
    return await db.insert(table, {columnQuestion: question, columnResponse: response});
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
*/