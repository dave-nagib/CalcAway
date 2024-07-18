import 'dao.dart';
import '../item.dart';

class ItemDAO extends DAO<Item> {

  @override
  Future<int> add(Item t) async {
    try {
      var db = await databaseConnection.db;
      // Return a non-negative integer with the id on normal completion
      return await db.insert('item', t.toMap());
    } on Exception catch (e) {
      print(e);
      return -1;
    }
  }

  @override
  Future<int> delete(Item t) async {
    try {
      var db = await databaseConnection.db;
      // Will return the number of rows affected on normal completion
      return await db.delete('item', where: 'name = ?', whereArgs: [t.name]);
    } on Exception catch (e) {
      print(e);
      return -1;
    }
  }

  @override
  Future<Item?> get(Object id) async {
    try {
      var db = await databaseConnection.db;
      // Obtain a list of string : value maps that match the name
      // Names are unique so we only return the first item in the list
      var mapList = await db.query('item', distinct: true, where: 'name = ?', whereArgs: [id as String]);
      // Returns the item object on normal completion
      return mapList.map((Map<String, Object?> map) => Item.fromMap(map)).first;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<Item>?> getAll() async {
    try {
      var db = await databaseConnection.db;
      // Obtain a list of string : value maps ordered by the name.
      var mapList = await db.query('item', distinct: true, orderBy: 'name');
      // Returns all items on normal completion
      return mapList.map((Map<String, Object?> map) => Item.fromMap(map)).toList();
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<int> update(Item t) async {
    try {
      var db = await databaseConnection.db;
      // Will return the number of rows affected on normal completion
      return await db.update('item', t.toMap(), where: 'name = ?', whereArgs: [t.name]);
    } on Exception catch (e) {
      print(e);
      return -1;
    }
  }

}
