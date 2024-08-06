import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../customer_list/customer_database_helper.dart';

class ReservationDatabaseHelper {
  static final _databaseName = "CustomerDatabase.db";
  static final _databaseVersion = 1;
  static final reservationTable = 'reservation';

  // Column names for the reservation table
  static final columnReservationId = '_id';
  static final columnReservationName = 'reservationName';
  static final columnCustomerIdFk = 'customerIdFk';
  static final columnFlight = 'flight';

  ReservationDatabaseHelper._privateConstructor();
  static final ReservationDatabaseHelper instance = ReservationDatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $reservationTable (
        $columnReservationId INTEGER PRIMARY KEY,
        $columnReservationName TEXT NOT NULL,
        $columnCustomerIdFk INTEGER NOT NULL,
        $columnFlight TEXT NOT NULL,
        FOREIGN KEY ($columnCustomerIdFk) REFERENCES ${CustomerDatabaseHelper.customerTable}(${CustomerDatabaseHelper.columnCustomerId})
      )
    ''');
  }

  Future<int> insertReservation(Map<String, dynamic> reservation) async {
    final db = await database;
    return await db.insert(reservationTable, reservation);
  }

  Future<List<Map<String, dynamic>>> getAllReservations() async {
    final db = await database;
    return await db.query(reservationTable);
  }

  Future<int> updateReservation(Map<String, dynamic> reservation) async {
    final db = await database;
    final id = reservation[columnReservationId];
    return await db.update(
      reservationTable,
      reservation,
      where: '$columnReservationId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteReservation(int id) async {
    final db = await database;
    return await db.delete(
      reservationTable,
      where: '$columnReservationId = ?',
      whereArgs: [id],
    );
  }
}
