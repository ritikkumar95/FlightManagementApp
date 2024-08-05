import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


import 'airplane.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('airplanes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE airplanes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT NOT NULL,
      passengers INTEGER NOT NULL,
      maxSpeed REAL NOT NULL,
      range REAL NOT NULL
    )
    ''');
  }

  Future<List<Airplane>> getAirplanes() async {
    final db = await instance.database;

    final result = await db.query('airplanes');

    return result.map((json) => Airplane.fromJson(json)).toList();
  }

  Future<int> insertAirplane(Airplane airplane) async {
    final db = await instance.database;

    return await db.insert('airplanes', airplane.toJson());
  }

  Future<int> updateAirplane(Airplane airplane) async {
    final db = await instance.database;

    return await db.update(
      'airplanes',
      airplane.toJson(),
      where: 'id = ?',
      whereArgs: [airplane.id],
    );
  }

  Future<int> deleteAirplane(int id) async {
    final db = await instance.database;

    return await db.delete(
      'airplanes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
