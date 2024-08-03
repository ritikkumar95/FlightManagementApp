import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';



// Helper class for managing the customer and reservation database
class CustomerDatabaseHelper {
  static final _databaseName = "CustomerDatabase.db"; // Name of the database
  static final _databaseVersion = 1; // Version of the database
  static final customerTable = 'customer'; // Customer table name
  static final reservationTable = 'reservation'; // Reservation table name

  // Column names for the customer table
  static final columnCustomerId = '_id';
  static final columnFirstName = 'firstName';
  static final columnLastName = 'lastName';
  static final columnAddress = 'address';
  static final columnBirthday = 'birthday';

  // Column names for the reservation table
  static final columnReservationId = '_id';
  static final columnReservationName = 'reservationName';
  static final columnCustomerIdFk = 'customerId';
  static final columnFlight = 'flight';

  // Singleton pattern implementation
  CustomerDatabaseHelper._privateConstructor();
  static final CustomerDatabaseHelper instance = CustomerDatabaseHelper._privateConstructor();

  static Database? _database;

  // Get a reference to the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // Create the customer and reservation tables
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $customerTable (
        $columnCustomerId INTEGER PRIMARY KEY,
        $columnFirstName TEXT NOT NULL,
        $columnLastName TEXT NOT NULL,
        $columnAddress TEXT NOT NULL,
        $columnBirthday TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $reservationTable (
        $columnReservationId INTEGER PRIMARY KEY,
        $columnReservationName TEXT NOT NULL,
        $columnCustomerIdFk INTEGER NOT NULL,
        $columnFlight TEXT NOT NULL,
        FOREIGN KEY ($columnCustomerIdFk) REFERENCES $customerTable ($columnCustomerId)
      )
    ''');
  }

  // Insert a customer into the database
  Future<int> insertCustomer(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(customerTable, row);
  }

  // Retrieve all customers from the database
  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    Database db = await instance.database;
    return await db.query(customerTable);
  }

  // Update a customer in the database
  Future<int> updateCustomer(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnCustomerId];
    return await db.update(customerTable, row, where: '$columnCustomerId = ?', whereArgs: [id]);
  }

  // Delete a customer from the database
  Future<int> deleteCustomer(int id) async {
    Database db = await instance.database;
    return await db.delete(customerTable, where: '$columnCustomerId = ?', whereArgs: [id]);
  }

  // Insert a reservation into the database
  Future<int> insertReservation(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(reservationTable, row);
  }

  // Retrieve all reservations from the database
  Future<List<Map<String, dynamic>>> getAllReservations() async {
    Database db = await instance.database;
    return await db.query(reservationTable);
  }

  // Retrieve a specific reservation by ID
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

  // Update a reservation in the database
  Future<int> updateReservation(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnReservationId];
    return await db.update(reservationTable, row, where: '$columnReservationId = ?', whereArgs: [id]);
  }

  // Delete a reservation from the database
  Future<int> deleteReservation(int id) async {
    Database db = await instance.database;
    return await db.delete(reservationTable, where: '$columnReservationId = ?', whereArgs: [id]);
  }
}
