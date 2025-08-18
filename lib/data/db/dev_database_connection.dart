import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_connection.dart';

class DevDatabaseConnection extends DatabaseConnection {

  _dbCreate(Database db, int version) async {
    // Create tables as in the parent class
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
      CREATE TABLE item_discount (
        item_id INTEGER PRIMARY KEY,
        discount REAL CHECK(discount > 0.0 AND discount <= 100.0),
        FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE CASCADE
      );
    ''');
    await db.execute('''
      CREATE TABLE receipt (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT DEFAULT CURRENT_TIMESTAMP
      );
    ''');
    await db.execute('''
      CREATE TABLE receipt_items (
        receipt_id INTEGER NOT NULL,
        item_id INTEGER DEFAULT 0,
        price REAL NOT NULL,
        count INTEGER NOT NULL CHECK(count > 0),
        discount REAL DEFAULT 0.0 CHECK(discount >= 0.0 AND discount <= 100.0),
        FOREIGN KEY (receipt_id) REFERENCES receipt(id) ON DELETE CASCADE,
        FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE SET DEFAULT
      );
    ''');
  }

  Future<void> _populateTestData(Database db) async {
    return db.transaction((txn) async {
      // Insert 7 items into the item table
      await txn.insert('item', {'name': 'Item A', 'price': 10.0}); // 1
      await txn.insert('item', {'name': 'Item B', 'price': 50.0}); // 2
      await txn.insert('item', {'name': 'أيتم سي دوني', 'price': 100.0}); // 3
      await txn.insert('item', {'name': 'An astonishing peculiar exquisite whimsical item', 'price': 500.0}); // 4
      await txn.insert('item', {'name': 'Item 3amer', 'price': 1000.0}); // 5
      await txn.insert('item', {'name': 'أيتم عربي اسمه طويل شويتين معلش بقى دنيا هنعمل ايه', 'price': 200.0}); // 6
      await txn.insert('item', {'name': 'Item D', 'price': 300.0}); // 7

      // Insert 3 discounts into the item_discount table
      await txn.insert('item_discount', {'item_id': 3, 'discount': 80.0});
      await txn.insert('item_discount', {'item_id': 2, 'discount': 10.0});
      await txn.insert('item_discount', {'item_id': 4, 'discount': 15.0});

      // Insert 4 receipts into the receipt table
      int receipt1 = await txn.insert('receipt', {});
      await txn.insert('receipt_items', {'receipt_id': receipt1, 'item_id': 1, 'price': 10.0, 'count': 10, 'discount': 0.0});
      await txn.insert('receipt_items', {'receipt_id': receipt1, 'item_id': 2, 'price': 50.0, 'count': 2, 'discount': 10.0});
      await txn.insert('receipt_items', {'receipt_id': receipt1, 'item_id': 3, 'price': 100.0, 'count': 6, 'discount': 80.0});

      int receipt2 = await txn.insert('receipt', {});
      await txn.insert('receipt_items', {'receipt_id': receipt2, 'item_id': 4, 'price': 500.0, 'count': 1, 'discount': 15.0});

      int receipt3 = await txn.insert('receipt', {});
      await txn.insert('receipt_items', {'receipt_id': receipt3, 'item_id': 5, 'price': 1000.0, 'count': 12, 'discount': 0.0});
      await txn.insert('receipt_items', {'receipt_id': receipt3, 'item_id': 6, 'price': 200.0, 'count': 1, 'discount': 50.0});

      int receipt4 = await txn.insert('receipt', {});
      await txn.insert('receipt_items', {'receipt_id': receipt4, 'item_id': 6, 'price': 200.0, 'count': 4, 'discount': 0.0});
      await txn.insert('receipt_items', {'receipt_id': receipt4, 'item_id': 7, 'price': 300.0, 'count': 2, 'discount': 0.0});
    });
  }

  _initializeDatabase() async {
    String dbPath = join(await getDatabasesPath(), 'calcaway_dev_db.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _dbCreate,
      onConfigure: (Database db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (Database db) async {
        // Clear and repopulate the database with test data
        await db.delete('receipt_items');
        await db.delete('receipt');
        await db.delete('item_discount');
        await db.delete('item', where: 'id > ?', whereArgs: [0]);
        // Repopulate with test data
        await _populateTestData(db);
      },
    );
  }
}