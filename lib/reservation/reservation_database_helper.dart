import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class ReservationDatabaseHelper {
  static const _databaseName = "CustomerDatabase.db";
  static const _databaseVersion = 1;
  static const reservationTable = 'reservation';

  // Column names for the reservation table
  static const columnReservationId = '_id';
  static const columnReservationName = 'reservationName';
  static const columnCustomerIdFk = 'customerId';
  static const columnFlight = 'flight';

  // Singleton pattern implementation
  ReservationDatabaseHelper._privateConstructor();
  static final ReservationDatabaseHelper instance = ReservationDatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $reservationTable (
        $columnReservationId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnReservationName TEXT NOT NULL,
        $columnCustomerIdFk INTEGER NOT NULL,
        $columnFlight TEXT NOT NULL,
        FOREIGN KEY ($columnCustomerIdFk) REFERENCES customer (_id)
      )
    ''');
  }

  Future<int> insertReservation(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(reservationTable, row);
  }

  Future<List<Map<String, dynamic>>> getAllReservations() async {
    Database db = await instance.database;
    return await db.query(reservationTable);
  }

  Future<int> updateReservation(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnReservationId];
    return await db.update(reservationTable, row, where: '$columnReservationId = ?', whereArgs: [id]);
  }

  Future<int> deleteReservation(int id) async {
    Database db = await instance.database;
    return await db.delete(reservationTable, where: '$columnReservationId = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getReservationById(int id) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      reservationTable,
      where: '$columnReservationId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getReservationsForCustomer(int customerId) async {
    Database db = await instance.database;
    return await db.query(
      reservationTable,
      where: '$columnCustomerIdFk = ?',
      whereArgs: [customerId],
    );
  }
}
