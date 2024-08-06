import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ReservationDatabaseHelper {
  static final ReservationDatabaseHelper instance = ReservationDatabaseHelper._privateConstructor();
  static Database? _database;

  ReservationDatabaseHelper._privateConstructor();

  static const String tableReservation = 'reservation';
  static const String columnReservationId = '_id';
  static const String columnReservationName = 'name';
  static const String columnCustomerIdFk = 'customer_id_fk';
  static const String columnFlight = 'flight';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'reservations.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableReservation (
        $columnReservationId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnReservationName TEXT NOT NULL,
        $columnCustomerIdFk INTEGER NOT NULL,
        $columnFlight TEXT NOT NULL,
        FOREIGN KEY ($columnCustomerIdFk) REFERENCES customer(id)
      )
    ''');
  }

  Future<int> insertReservation(Map<String, dynamic> reservation) async {
    final db = await instance.database;
    return await db.insert(tableReservation, reservation);
  }

  Future<List<Map<String, dynamic>>> getAllReservations() async {
    final db = await instance.database;
    return await db.query(tableReservation);
  }

  Future<int> updateReservation(Map<String, dynamic> reservation) async {
    final db = await instance.database;
    final id = reservation[columnReservationId];
    return await db.update(
      tableReservation,
      reservation,
      where: '$columnReservationId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteReservation(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableReservation,
      where: '$columnReservationId = ?',
      whereArgs: [id],
    );
  }
}