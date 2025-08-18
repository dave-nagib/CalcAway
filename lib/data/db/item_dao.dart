import 'package:calc_away/data/db/database_connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'dao.dart';
import '../models/item.dart';

class ItemDAO extends DAO<Item> {

  ItemDAO(DatabaseConnection dc) : super(dc);

  @override
  Future<Item?> add(Item t, {double? discount}) async {
    try {
      var db = await databaseConnection.db;
      return await db.transaction((txn) async {
        // Return a non-negative integer with the id on normal completion
        int iid = await txn.insert('item', t.toMap());
        if (discount != null) {
          await txn.insert('item_discount', {'item_id': iid, 'discount': discount});
        }
        return Item(id: iid, name: t.name, price: t.price, discontinued: t.discontinued);
      });
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

  /// Sets the `discontinued` flag of an item to 1 in the database. Returns the number of rows affected normally and -1 on encountering an error.
  Future<int> discontinue(int id) async {
    try {
      var db = await databaseConnection.db;
      return await db.update('item', {'discontinued': 1}, where: 'id = ?', whereArgs: [id]);
    } on Exception catch(e,st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return -1;
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
  Future<List<Item>?> getMultiple({String? where, List<String>? whereArgs, String sortBy = 'name', bool ascending = true}) async {
    try {
      var db = await databaseConnection.db;
      // Obtain a list of string : value maps ordered by the sortBy parameter.
      List<Map<String, Object?>> mapList;
      if (sortBy == 'popularity') {
        String whereStr = (where != null && where.trim().isNotEmpty)? 'WHERE $where' : '';
        mapList = await db.rawQuery('''
          SELECT item.*, COALESCE(SUM(receipt_items.count), 0) AS sales_count
          FROM item
          LEFT JOIN receipt_items ON item.id = receipt_items.item_id
          $whereStr
          GROUP BY item.id 
          ORDER BY sales_count ${ascending? 'ASC' : 'DESC'}
        ''', whereArgs);
      } else {
        mapList = await db.query('item', orderBy: sortBy + (ascending? 'ASC' : 'DESC'), where: where, whereArgs: whereArgs);
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
  Future<int> update(Item t, {double? discount}) async {
    try {
      var db = await databaseConnection.db;
      // Will return the number of rows affected on normal completion
      return await db.transaction((txn) async {
        int affectedItem = await txn.update('item', t.toMap(), where: 'id = ?', whereArgs: [t.id]);
        int affectedDiscount = 0;
        if (discount != null) {
          if (discount == 0.0) {
            affectedDiscount = await txn.delete('item_discount', where: 'item_id = ?', whereArgs: [t.id!]);
          } else {
            affectedDiscount = await txn.insert('item_discount', {'item_id': t.id!, 'discount': discount}, conflictAlgorithm: ConflictAlgorithm.replace);
          }
        }
        return affectedItem + affectedDiscount;
      });
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

  Future<double?> getDiscount(int id) async {
    var db = await databaseConnection.db;
    try {
      var mapList = await db.query('item_discount', where: 'id = ?', whereArgs: [id]);
      if (mapList.isEmpty) {
        return 0.0;
      }
      return mapList.map((Map<String, Object?> map) => map['discount'] as double).first;
    } on Exception catch(e,st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return null;
    }
  }

  /// Returns a map of item id: discount pairs given a list of item ids.
  /// Items with no default discount will not be included in the map.
  Future<Map<int, double>> getDiscounts(List<int> ids) async {
    try {
      var db = await databaseConnection.db;
      var mapList = await db.query('item_discount', where: 'id IN (${ids.join(', ')})');
      Map<int, double> discounts = {};
      for (final map in mapList) {
        discounts[map['item_id'] as int] = map['discount'] as double;
      }
      return discounts;
    } on Exception catch(e,st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return {};
    }
  }

  Future<int> removeDiscount(int id) async {
    try {
      var db = await databaseConnection.db;
      // Will return the number of rows affected on normal completion
      return db.delete('item_discount', where: 'item_id = ?', whereArgs: [id]);
    } on Exception catch(e,st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return -1;
    }
  }

  /// Returns a map of item id: count pairs given a list of item ids.
  Future<Map<int, int>> saleCounts(List<int> ids) async {
    try {
      var db = await databaseConnection.db;
      List<Map<String, Object?>> mapList = await db.rawQuery('''
          SELECT item.*, COALESCE(SUM(receipt_items.count), 0) AS sales_count
          FROM item
          LEFT JOIN receipt_items ON item.id = receipt_items.item_id
          WHERE item.id IN (${ids.join(', ')})
          GROUP BY item.id 
          ORDER BY sales_count DESC
        ''');
      Map<int,int> itemCounts = {};
      for (final map in mapList) {
        itemCounts[map['id'] as int] = map['sales_count'] as int? ?? 0;
      }
      return itemCounts;
    } on Exception catch(e,st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return {};
    }
  }

}
