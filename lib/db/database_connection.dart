import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {

  // Single Database object instance that will be referenced across the whole application
  static Database? _db;

  // Function which executes the database creation if the schema doesn't exist
  _dbCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE item (
        name TEXT PRIMARY KEY,
        price REAL
      );
      
      CREATE TABLE receipt (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT DEFAULT CURRENT_TIMESTAMP
      );
      
      CREATE TABLE receipt_details (
        item_name TEXT,
        transact_id INTEGER,
        count INTEGER NOT NULL CHECK(count > 0),
        FOREIGN KEY (item_name) REFERENCES item(name),
        FOREIGN KEY (transact_id) REFERENCES receipt(id)
      );
    ''');
  }

  // Function which is used to initialize the database instance if it is not already initialized
  _initializeDatabase() async {
    // Get the path to the database file
    String dbPath = join(await getDatabasesPath() , 'calcaway_db.db');
    // Open the connection to the database
    return await openDatabase(
        dbPath,
        version: 1,
        onCreate: _dbCreate,
        onConfigure: (Database db) async {await db.execute('PRAGMA foreign_keys = ON');} // Enables foreign key constraints
    );
  }

  // Getter method for the database instance singleton
  Future<Database> get db async {
    _db ??= await _initializeDatabase();
    return _db!;
  }
}