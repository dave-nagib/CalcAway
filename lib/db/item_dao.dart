import 'package:flutter/cupertino.dart';
import 'dao.dart';
import '../item.dart';

class ItemDAO extends DAO<Item> {

  @override
  Future<Item?> add(Item t) async {
    try {
      var db = await databaseConnection.db;
      // Return a non-negative integer with the id on normal completion
      int iid = await db.insert('item', t.toMap());
      return Item(id: iid, name: t.name, price: t.price);
    } on Exception catch(e,st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return null;
    }
  }

  @override
  Future<int> delete(Item t) async {
    try {
      var db = await databaseConnection.db;
      // Will return the number of rows affected on normal completion
      return await db.delete('item', where: 'id = ?', whereArgs: [t.id]);
    } on Exception catch(e,st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return -1;
    }
  }

  @override
  Future<Item?> get(Object id) async {
    try {
      var db = await databaseConnection.db;
      // Obtain a list of string : value maps that match the name
      // Names are unique so we only return the first item in the list
      var map = (await db.query('item', where: 'id = ?', whereArgs: [id as int])).firstOrNull;
      if (map == null) throw Exception('Item not found.');
      // Returns the item object on normal completion
      return Item.fromMap(map);
    } on Exception catch(e,st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return null;
    }
  }

  @override
  Future<List<Item>?> getMultiple(String? where, List<String>? whereArgs) async {
    try {
      var db = await databaseConnection.db;
      // Obtain a list of string : value maps ordered by the name.
      var mapList = await db.query('item', orderBy: 'name', where: where, whereArgs: whereArgs);
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

}
