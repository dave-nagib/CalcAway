import 'package:calc_away/data/db/database_connection.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockDatabaseConnection implements DatabaseConnection {
  Database? _db;

  _create(Database db, int version) async {
    await db.execute('''
      CREATE TABLE item (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL,
        price REAL NOT NULL,
        discontinued INTEGER DEFAULT FALSE
      );
    ''');
    await db.insert('item', {'id': 0, 'name': 'deleted item', 'price': 0.0});
    await db.execute('''
      CREATE TABLE receipt (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT DEFAULT CURRENT_TIMESTAMP
      );
    ''');
    await db.execute('''
      CREATE TABLE receipt_details (
        transact_id INTEGER NOT NULL,
        item_id INTEGER DEFAULT 0,
        price REAL NOT NULL,
        count INTEGER NOT NULL CHECK(count > 0),
        FOREIGN KEY (transact_id) REFERENCES receipt(id) ON DELETE CASCADE,
        FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE SET DEFAULT
      );
    ''');
  }

  _initialize() async {
    sqfliteFfiInit();
    return await databaseFactoryFfi.openDatabase(inMemoryDatabasePath,
        options: OpenDatabaseOptions(
            onCreate: _create,
            version: 1,
            onConfigure: (Database db) async {
              await db.execute('PRAGMA foreign_keys = ON');
            }));
  }

  @override
  Future<Database> get db async {
    _db ??= await _initialize();
    return _db!;
  }

  clearTables() async {
    await _db!.delete('receipt');
    await _db!.delete('item', where: 'id > ?', whereArgs: [0]);
  }

  close() async {
    await _db?.close();
  }
}
