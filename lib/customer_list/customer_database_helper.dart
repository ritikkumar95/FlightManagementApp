import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class CustomerDatabaseHelper {
  static final _databaseName = "CustomerDatabase.db";
  static final _databaseVersion = 1;
  static final table = 'customer';

  static final columnId = '_id';
  static final columnFirstName = 'firstName';
  static final columnLastName = 'lastName';
  static final columnAddress = 'address';
  static final columnBirthday = 'birthday';

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
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnFirstName TEXT NOT NULL,
        $columnLastName TEXT NOT NULL,
        $columnAddress TEXT NOT NULL,
        $columnBirthday TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertCustomer(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> updateCustomer(Map<String, dynamic> row) async {
    Database db = await instance.database;
    if (row[columnId] == null) {
      throw ArgumentError('Customer ID is null');
    }
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteCustomer(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
