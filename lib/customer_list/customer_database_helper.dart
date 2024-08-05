import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CustomerDatabaseHelper {
  static final _databaseName = "CustomerDatabase.db";
  static final _databaseVersion = 1;

  static final customerTable = 'customer';
  static final reservationTable = 'reservation';

  static final columnCustomerId = '_id';
  static final columnFirstName = 'firstName';
  static final columnLastName = 'lastName';
  static final columnAddress = 'address';
  static final columnBirthday = 'birthday';

  static final columnReservationId = '_id';
  static final columnReservationName = 'reservationName';
  static final columnCustomerIdFk = 'customerId';
  static final columnFlight = 'flight';

  CustomerDatabaseHelper._privateConstructor();
  static final CustomerDatabaseHelper instance = CustomerDatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $customerTable (
        $columnCustomerId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnFirstName TEXT NOT NULL,
        $columnLastName TEXT NOT NULL,
        $columnAddress TEXT NOT NULL,
        $columnBirthday TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $reservationTable (
        $columnReservationId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnReservationName TEXT NOT NULL,
        $columnCustomerIdFk INTEGER NOT NULL,
        $columnFlight TEXT NOT NULL,
        FOREIGN KEY ($columnCustomerIdFk) REFERENCES $customerTable ($columnCustomerId)
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle schema migrations if needed
  }

  Future<int> insertCustomer(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(customerTable, row);
  }

  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    Database db = await instance.database;
    return await db.query(customerTable);
  }

  Future<int> insertReservation(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(reservationTable, row);
  }

  Future<List<Map<String, dynamic>>> getAllReservations() async {
    Database db = await instance.database;
    return await db.query(reservationTable);
  }

  Future<Map<String, dynamic>?> getCustomerById(int id) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      customerTable,
      where: '$columnCustomerId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
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
}
