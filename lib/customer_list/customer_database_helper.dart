import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Helper class for managing the customer database
class CustomerDatabaseHelper {
  static const _databaseName = "CustomerDatabase.db"; // Name of the database
  static const _databaseVersion = 1; // Version of the database
  static const table = 'customer'; // Table name

  // Column names
  static const columnId = '_id';
  static const columnFirstName = 'firstName';
  static const columnLastName = 'lastName';
  static const columnAddress = 'address';
  static const columnBirthday = 'birthday';

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

  // Create the customer table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnFirstName TEXT NOT NULL,
        $columnLastName TEXT NOT NULL,
        $columnAddress TEXT NOT NULL,
        $columnBirthday TEXT NOT NULL
      )
    ''');
  }

  // Insert a customer into the database
  Future<int> insertCustomer(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // Retrieve all customers from the database
  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // Update a customer in the database
  Future<int> updateCustomer(Map<String, dynamic> row) async {
    Database db = await instance.database;
    if (row[columnId] == null) {
      throw ArgumentError('Customer ID is null');
    }
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }
// Get a customer by ID
  Future<Map<String, dynamic>?> getCustomerById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null; // Return null if no customer found
  }

  // Delete a customer from the database
  Future<int> deleteCustomer(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}