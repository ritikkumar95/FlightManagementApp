import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CustomerDatabaseHelper {
  static final _databaseName = "CustomerDatabase.db";
  static final _databaseVersion = 1;
  static final customerTable = 'customer';

  // Column names for the customer table
  static final columnCustomerId = '_id';
  static final columnFirstName = 'firstName';
  static final columnLastName = 'lastName';
  static final columnAddress = 'address';
  static final columnBirthday = 'birthday';

  // Singleton pattern implementation
  CustomerDatabaseHelper._privateConstructor();
  static final CustomerDatabaseHelper instance = CustomerDatabaseHelper._privateConstructor();

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
      CREATE TABLE $customerTable (
        $columnCustomerId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnFirstName TEXT NOT NULL,
        $columnLastName TEXT NOT NULL,
        $columnAddress TEXT NOT NULL,
        $columnBirthday TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertCustomer(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(customerTable, row);
  }

  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    Database db = await instance.database;
    return await db.query(customerTable);
  }

  Future<int> updateCustomer(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnCustomerId];
    return await db.update(customerTable, row, where: '$columnCustomerId = ?', whereArgs: [id]);
  }

  Future<int> deleteCustomer(int id) async {
    Database db = await instance.database;
    return await db.delete(customerTable, where: '$columnCustomerId = ?', whereArgs: [id]);
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
}
