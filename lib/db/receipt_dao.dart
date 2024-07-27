import 'package:calc_away/db/database_connection.dart';
import 'package:flutter/cupertino.dart';
import '../item.dart';
import 'package:sqflite/sqflite.dart';
import '../receipt.dart';
import 'dao.dart';

class ReceiptDAO extends DAO<Receipt> {

  ReceiptDAO(DatabaseConnection dc) : super(dc);

  @override
  Future<Receipt?> add(Receipt t) async {
    var db = await databaseConnection.db;
    try {
      // Add the receipt as a transaction to keep the operation atomic
      return await db.transaction((txn) async {
        // The id and timestamp are both automatic, so we insert entry to get id then query to get timestamp
        int recId = await txn.insert('receipt', {});
        var ret = (await txn.query('receipt', where: 'id = ?', whereArgs: [recId])).firstOrNull;
        if (ret == null) throw Exception('Error in finding receipt timestamp.');
        // Construct a new receipt object
        Receipt rec = Receipt(
            id: recId,
            timestamp: DateTime.parse(ret['timestamp'] as String),
            nonZeroItems: t.nonZeroItems
        );
        // Batch insert the receipt items into the receipt_details table
        Batch batch = txn.batch();
        for (var entry in t.nonZeroItems.entries) {
          batch.insert('receipt_details', {'transact_id': recId, 'item_id': entry.key.id, 'count': entry.value});
        }
        await batch.commit();
        // Return the created Receipt object
        return rec;
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
      return await db.delete('receipt', where: 'id = ?', whereArgs: [id]);
    } on Exception catch(e,st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return -1;
    }
  }

  @override
  Future<Receipt?> get(int id) async {
    var db = await databaseConnection.db;
    try {
      // Fetch the receipt entry by id
      var idAndTime = (await db.query('receipt', where: 'id = ?', whereArgs: [id])).firstOrNull;
      if (idAndTime == null) throw Exception('Error in finding receipt entry.');
      // Construct a new item list object
      Map<Item,int> items = {};
      // Fetch all items included in receipt from receipt_details
      var itemMaps = await db.query('receipt_details', where: 'transact_id = ?', whereArgs: [id]);
      if (itemMaps.isEmpty) throw Exception('Empty receipt found.');
      for (Map entry in itemMaps) {
        var itemMap = (await db.query('item', where: 'id = ?', whereArgs: [entry['item_id']])).first;
        items[Item.fromMap(itemMap)] = entry['count'];
      }
      // Return the Receipt object
      return Receipt(
          id: id,
          timestamp: DateTime.parse(idAndTime['timestamp'] as String),
          nonZeroItems: items
      );
    } on Exception catch(e,st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return null;
    }
  }

  /// Returns a list of multiple receipts without their items list from the database with filtering options. Returns null on error.
  @override
  Future<List<Receipt>?> getMultiple({String? where, List<String>? whereArgs}) async {
    var db = await databaseConnection.db;
    try {
      // Fetch all receipts and order them from newest to oldest
      List<Map<String, Object?>> maps;
      if (where == null) {
        maps = await db.query('receipt', orderBy: 'timestamp DESC');
      } else {
        maps = await db.query('receipt', orderBy: 'timestamp DESC', where: where, whereArgs: whereArgs);
      }
      return maps.map((e) => {
            Receipt(
                id: e['id'] as int,
                timestamp: DateTime.parse(e['timestamp'] as String),
                nonZeroItems: {}
            )
      }) as List<Receipt>;
    } on Exception catch(e,st) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: st);
      return null;
    }
  }

  @override
  Future<int> update(Receipt t) async {
    // TODO: implement update
    throw UnimplementedError();
  }

}