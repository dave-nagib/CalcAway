import 'package:calc_away/db/database_connection.dart';
import 'package:flutter/cupertino.dart';
import 'dao.dart';
import '../item.dart';

class ItemDAO extends DAO<Item> {

  ItemDAO(DatabaseConnection dc) : super(dc);

  @override
  Future<Item?> add(Item t) async {
    try {
      var db = await databaseConnection.db;
      // Return a non-negative integer with the id on normal completion
      int iid = await db.insert('item', t.toMap());
      return Item(id: iid, name: t.name, price: t.price, discontinued: t.discontinued);
    } on Exception catch(e,st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return null;
    }
  }

  @override
  Future<int> delete(int id) async {
    try {
      var db = await databaseConnection.db;
      // Will return the number of rows affected on normal completion
      return await db.delete('item', where: 'id = ?', whereArgs: [id]);
    } on Exception catch(e,st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return -1;
    }
  }

  Future<int> discontinue(int id) async {
    try {
      var db = await databaseConnection.db;
      int rows = await db.update('item', {'discontinued': 1}, where: 'id = ?', whereArgs: [id]);
      if (rows == 0) throw Exception('Item not found.');
      return 1;
    } on Exception catch(e,st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return 0;
    }
  }

  @override
  Future<Item?> get(int id) async {
    try {
      var db = await databaseConnection.db;
      // Obtain a list of string : value maps that match the name
      // Names are unique so we only return the first item in the list
      var map = await db.query('item', where: 'id = ?', whereArgs: [id]);
      if (map.isEmpty) throw Exception('Item not found.');
      // Returns the item object on normal completion
      return Item.fromMap(map.first);
    } on Exception catch(e,st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return null;
    }
  }

  @override
  Future<List<Item>?> getMultiple({String? where, List<String>? whereArgs}) async {
    try {
      var db = await databaseConnection.db;
      // Obtain a list of string : value maps ordered by the name.
      List<Map<String, Object?>> mapList;
      if (where == null) {
        mapList = await db.query('item', orderBy: 'name');
      } else {
        mapList = await db.query('item', orderBy: 'name', where: where, whereArgs: whereArgs);
      }
      // Returns all items on normal completion
      return mapList.map((Map<String, Object?> map) => Item.fromMap(map)).toList();
    } on Exception catch(e,st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return null;
    }
  }

  @override
  Future<int> update(Item t) async {
    try {
      var db = await databaseConnection.db;
      // Will return the number of rows affected on normal completion
      return await db.update('item', t.toMap(), where: 'id = ?', whereArgs: [t.id]);
    } on Exception catch(e,st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return -1;
    }
  }

  Future<bool> nameAvailable(String name) async {
    try {
      var db = await databaseConnection.db;
      // Will return the number of rows affected on normal completion
      var itemList = await db.query('item', where: 'name = ?', whereArgs: [name]);
      return itemList.isEmpty;
    } on Exception catch(e,st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return false;
    }
  }

}
