import 'package:calc_away/db/item_dao.dart';
import 'package:calc_away/db/receipt_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'mocks/mock_database_connection.dart';
import 'package:test/test.dart';
import 'package:calc_away/item.dart';
import 'package:calc_away/receipt.dart';

void main() {

  late ReceiptDAO sut;
  late ItemDAO itemDAO;
  late MockDatabaseConnection mdc;

  List<String> names = ['Test Item 1', 'Test Item 2', 'Test Item 3', 'Test Item 4', 'Test Item 5', 'Test Item 6'];
  List<double> prices = [3.99, 5.66, 1.23, 0.5, 10.0, 150.0];
  List<int> counts = [1,2,2,8,5,1];
  late List<Item> itemsInDB;

  setUpAll(() {
    mdc = MockDatabaseConnection();

  });

  setUp(() async {
    sut = ReceiptDAO(mdc);
    itemDAO = ItemDAO(mdc);
    itemsInDB = [];
    for (int i=0 ; i<names.length ; i++) {
      itemsInDB.add(await itemDAO.add(Item(name: names[i], price: prices[i])) as Item);
    }
  });

  tearDown(() async => { await mdc.clearTables()} );

  tearDownAll(() async => { await mdc.close() });

  test(
    'Adding a receipt.',
      () async {
        // Construct receipt map and object
        Map<Item,int> map = {};
        for (int i=0 ; i<6 ; i++) {
          map[itemsInDB[i]] = counts[i];
        }
        // Add items to the item database
        Receipt? created = await sut.add(Receipt(nonZeroItems: map));
        expect(created, isNotNull);
        expect(created!.id, isNotNull);
        expect(created.id! > 0, isTrue);
        expect(created.timestamp, isNotNull);
        expect(DateTime.now().isAfter(created.timestamp!), true);
      }
  );

  test(
    'Fetching a receipt only.',
      () async {
        // Add a new entry to the receipt table
        int id = await (await mdc.db).rawInsert('INSERT INTO receipt(id) VALUES(NULL);');
        // Add corresponding items to the receipt_details table
        Batch b = (await mdc.db).batch();
        for (int i=0 ; i<names.length ; i++) {
          b.insert('receipt_details', {'transact_id': id, 'item_id': itemsInDB[i].id, 'count': counts[i]});
        }
        await b.commit();
        // Fetch receipt using DAO
        Receipt? rec = await sut.get(id);
        expect(rec!, isNotNull);
        expect(rec.timestamp, isNotNull);
        expect(rec.id, id);
        expect(rec.nonZeroItems, isNotNull);
        expect(rec.nonZeroItems, isNotEmpty);
        for(var entry in rec.nonZeroItems.entries) {
          int i = itemsInDB.indexOf(entry.key);
          expect(i != -1, isTrue);
          expect(entry.key.id, itemsInDB[i].id);
          expect(entry.value, counts[i]);
        }
      }
  );

  test(
    'Adding and fetching a receipt.',
      () async {
        // Construct receipt map and object
        Map<Item,int> map = {};
        for (int i=0 ; i<6 ; i++) {
          map[itemsInDB[i]] = counts[i];
        }
        // Add items to the item database
        Receipt? created = await sut.add(Receipt(nonZeroItems: map));
        expect(created, isNotNull);
        expect(created!.id, isNotNull);
        // Fetch receipt using DAO
        Receipt? rec = await sut.get(created.id!);
        expect(rec!, isNotNull);
        expect(rec.timestamp, isNotNull);
        expect(rec.id, created.id);
        expect(rec.nonZeroItems, isNotNull);
        expect(rec.nonZeroItems, isNotEmpty);
        for(var entry in rec.nonZeroItems.entries) {
          int i = itemsInDB.indexOf(entry.key);
          expect(i != -1, isTrue);
          expect(entry.value, counts[i]);
        }
      }
  );

  test(
    'Fetch nonexistent receipt.',
      () async {
        expect(await sut.get(999), isNull);
      }
  );

  test(
    'Deleting an receipt only.',
      () async {
        // Add a new entry to the receipt table
        int id = await (await mdc.db).rawInsert('INSERT INTO receipt(id) VALUES(NULL);');
        // Add corresponding items to the receipt_details table
        Batch b = (await mdc.db).batch();
        for (int i=0 ; i<names.length ; i++) {
          b.insert('receipt_details', {'transact_id': id, 'item_id': itemsInDB[i].id, 'count': counts[i]});
        }
        await b.commit();
        // Delete the receipt with DAO
        int affected1 = await sut.delete(id);
        expect(affected1, 1);
        // This should also automatically delete the associated rows in receipt_details
        int affected2 = await (await mdc.db).delete('receipt_details', where: 'transact_id = ?', whereArgs: [id]);
        expect(affected2, 0);
      }
  );

  test(
    'Delete nonexistent receipt.',
      () async {
        expect(await sut.delete(999), 0);
      }
  );

  test(
    'Add, fetch, then delete receipt.',
      () async {
        // Construct receipt map and object
        Map<Item,int> map = {};
        for (int i=0 ; i<3 ; i++) {
          map[itemsInDB[i]] = counts[i];
        }
        // Add items to the item database
        Receipt? created = await sut.add(Receipt(nonZeroItems: map));
        expect(created, isNotNull);
        expect(created!.id, isNotNull);
        // Fetch receipt using DAO
        Receipt? rec = await sut.get(created.id!);
        expect(rec!, isNotNull);
        expect(rec.timestamp, isNotNull);
        expect(rec.id, created.id);
        expect(rec.nonZeroItems, isNotNull);
        expect(rec.nonZeroItems, isNotEmpty);
        for(var entry in rec.nonZeroItems.entries) {
          int i = itemsInDB.indexOf(entry.key);
          expect(i != -1, isTrue);
          expect(entry.value, counts[i]);
        }
        // Delete the receipt with DAO
        int affected = await sut.delete(created.id!);
        expect(affected, 1);
      }
  );

  test(
    'Fetch all receipts only.',
      () async {
        // Add two new entries to the receipt table
        List<int> ids = [];
        ids.add(await (await mdc.db).rawInsert('INSERT INTO receipt(id) VALUES(NULL);'));
        ids.add(await (await mdc.db).rawInsert('INSERT INTO receipt(id) VALUES(NULL);'));
        // Add corresponding items to the receipt_details table for each receipt
        Batch b1 = (await mdc.db).batch();
        for (int i=0 ; i<names.length-3 ; i++) {
          b1.insert('receipt_details', {'transact_id': ids[0], 'item_id': itemsInDB[i].id, 'count': counts[i]});
        }
        await b1.commit();
        Batch b2 = (await mdc.db).batch();
        for (int i=names.length-3 ; i<names.length ; i++) {
          b2.insert('receipt_details', {'transact_id': ids[1], 'item_id': itemsInDB[i].id, 'count': counts[i]});
        }
        await b2.commit();
        // Fetch all receipts
        List<Receipt>? fetched = await sut.getMultiple();
        expect(fetched!, isNotNull);
        for (int i=0 ; i<fetched.length ; i++){
          expect(fetched[i].timestamp, isNotNull);
          expect(ids.contains(fetched[i].id), isTrue);
          expect(fetched[i].nonZeroItems, isNotNull);
        }
      }
  );

  test(
    'Add multiple receipts then fetch all.',
      () async {
        // Construct receipt maps
        List<Map<Item,int>> maps = [];
        int size = 2;
        for (int count=0 ; count<itemsInDB.length/size ; count++){
          Map<Item,int> map = {};
          for (int i = count*size; i < count*size+size; i++) { map[itemsInDB[i]] = counts[i]; }
          maps.add(map);
        }
        // Add items to the item database
        List<Receipt?> created = [];
        List<int> ids = [];
        for (int i=0 ; i<maps.length ; i++) {
          created.add(await sut.add(Receipt(nonZeroItems: maps[i])));
          expect(created[i], isNotNull);
          expect(created[i]!.id, isNotNull);
          ids.add(created[i]!.id!);
        }
        // Fetch all receipts
        List<Receipt>? fetched = await sut.getMultiple();
        expect(fetched!, isNotNull);
        expect(fetched.length, created.length);
        for (int i=0 ; i<fetched.length ; i++){
          expect(fetched[i].timestamp, isNotNull);
          expect(ids.contains(fetched[i].id), isTrue);
          expect(fetched[i].nonZeroItems, isNotNull);
        }
      }
  );

  test(
    'Add multiple receipts, then get multiple filtered by timestamp.',
      () async {
        // Construct receipt maps
        List<Map<Item,int>> maps = [];
        int size = 2;
        for (int count=0 ; count<itemsInDB.length/size ; count++){
          Map<Item,int> map = {};
          for (int i = count*size; i < count*size+size; i++) { map[itemsInDB[i]] = counts[i]; }
          maps.add(map);
        }
        // Add items to the item database with timestamps
        List<Receipt?> created = [];
        List<int> ids = [];
        List<DateTime> stamps = [DateTime(2024,5,2,14,30,23), DateTime(2024,8,2,11,14,56), DateTime(2024,9,22,0,5,7)];
        for (int i=0 ; i<maps.length ; i++) {
          created.add(await sut.add(Receipt(nonZeroItems: maps[i], timestamp: stamps[i])));
          expect(created[i], isNotNull);
          expect(created[i]!.id, isNotNull);
          ids.add(created[i]!.id!);
        }
        // Get multiple receipts and filter by timestamp
        List<Receipt>? fetched = await sut.getMultiple(where: 'timestamp >= ?', whereArgs: [DateTime(2024,8,2).toIso8601String()]);
        expect(fetched!, isNotNull);
        expect(fetched.length, 2);
        for (int i=0 ; i<fetched.length ; i++){
          expect(fetched[i].timestamp, isNotNull);
          expect(ids.contains(fetched[i].id), isTrue);
          expect(fetched[i].nonZeroItems, isNotNull);
        }
      }
  );
}