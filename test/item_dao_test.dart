import 'package:sqflite/sqflite.dart';
import 'mocks/mock_database_connection.dart';
import 'package:calc_away/db/item_dao.dart';
import 'package:test/test.dart';
import 'package:calc_away/item.dart';

void main() {

  late ItemDAO sut;
  late MockDatabaseConnection mdc;

  setUpAll(() => { mdc = MockDatabaseConnection() });

  setUp(() => { sut = ItemDAO(mdc) });

  tearDown(() async => { await mdc.clearTables()} );

  tearDownAll(() async => { await mdc.close() });

  test(
      'Adding an item.',
        () async {
          // Add item by DAO
          Item? created = await sut.add(Item(name: 'Test Item 1', price: 20.5));
          expect(created, isNotNull);
          expect(created!.id, isNotNull);
          expect(created.id! > 0, isTrue);
        }
  );

  test(
    'Fetching an item only.',
      () async {
        // Add item directly by db
        Item test = Item(name: 'Test Item 2', price: 4.99);
        int id = await (await mdc.db).insert('item', test.toMap());
        // Fetch item by DAO
        Item? fetched = await sut.get(id);
        expect(fetched, isNotNull);
        expect(fetched!.id, id);
        expect(fetched.name, test.name);
        expect(fetched.price, test.price);
      }
  );

  test(
    'Adding and fetching an item.',
      () async {
        // Add item by DAO
        Item? created = await sut.add(Item(name: 'Test Item 3', price: 404.0));
        expect(created!.id, isNotNull);
        expect(created.id! > 0, isTrue);
        // Fetch item by DAO
        Item? fetched = await sut.get(created.id!);
        expect(fetched, isNotNull);
        expect(fetched!.price, created.price);
        expect(fetched.name, created.name);
      }
  );

  test(
    'Fetch nonexistent item.',
      () async {
        try {
          await sut.get(999);
        } on Exception catch(e) {
          expect(e, 'Item not found.');
        }
      }
  );

  test(
    'Deleting an item only.',
      () async {
        // Add item directly by db
        Item test = Item(name: 'Test Item 4', price: 387.32);
        int id = await (await mdc.db).insert('item', test.toMap());
        // Delete item by DAO
        int rowsAffected = await sut.delete(id);
        expect(rowsAffected, 1);
      }
  );

  test(
    'Delete nonexistent item.',
      () async {
        expect(await sut.delete(999), 0);
      }
  );

  test(
    'Update an item only.',
      () async {
        // Add item directly by db
        Item test = Item(name: 'Test Item 5', price: 420.0);
        int id = await (await mdc.db).insert('item', test.toMap());
        // Update item by DAO
        int rowsAffected = await sut.update(Item(id: id, name: 'Updated Item 5', price: 42.0));
        expect(rowsAffected, 1);
      }
  );

  test(
    'Update then fetch.',
      () async {
        // Add item directly by db
        Item test = Item(name: 'Test Item 6', price: 200.0);
        int id = await (await mdc.db).insert('item', test.toMap());
        // Update item by DAO
        Item updated = Item(id: id, name: 'Updated Item 6', price: 202.4);
        int rowsAffected = await sut.update(updated);
        expect(rowsAffected, 1);
        // Fetch item by DAO
        Item? fetched = await sut.get(id);
        expect(fetched, isNotNull);
        expect(fetched!.id, updated.id);
        expect(fetched.name, updated.name);
        expect(fetched.price, updated.price);
      }
  );

  test(
    'Update nonexistent item.',
      () async {
        expect(await sut.update(Item(id: 909, name: 'Bogus Item', price: 10.63)), 0);
      }
  );

  test(
    'Add, fetch, update, fetch again, then delete.',
      () async {
        // Add item by DAO
        Item? created = await sut.add(Item(name: 'Test Item 7', price: 432.1));
        expect(created, isNotNull);
        expect(created!.id, isNotNull);
        expect(created.id! > 0, isTrue);
        // Fetch item by DAO before update
        Item? fetched1 = await sut.get(created.id!);
        expect(fetched1, isNotNull);
        expect(fetched1!.id, created.id);
        expect(fetched1.name, created.name);
        expect(fetched1.price, created.price);
        // Update item by DAO
        Item updated = Item(id: created.id, name: 'Updated Item 6', price: 321.0);
        int rowsAffected1 = await sut.update(updated);
        expect(rowsAffected1, 1);
        // Fetch item by DAO after update
        Item? fetched2 = await sut.get(created.id!);
        expect(fetched2, isNotNull);
        expect(fetched2!.id, updated.id);
        expect(fetched2.name, updated.name);
        expect(fetched2.price, updated.price);
        // Delete item by DAO
        int rowsAffected2 = await sut.delete(created.id!);
        expect(rowsAffected2, 1);
      }
  );

  test(
    'Delete and update negative ID.',
      () async {
        expect(await sut.delete(-1), 0);
        expect(await sut.update(Item(id: -2, name: 'Fake Item', price: 9.89)), 0);
      }
  );

  test(
    'Fetch all only.',
      () async {
        // Add multiple items directly by db
        Batch b = (await mdc.db).batch();
        List<Item> createdList = [];
        for (int i=0 ; i<10 ; i++) {
          Item t = Item(name: 'Fetch All Test Item $i', price: 3.22*i);
          createdList.add(t);
          b.insert('item', t.toMap());
        }
        await b.commit();
        // Fetch all items by DAO (the ones above)
        List<Item>? fetchedList = await sut.getMultiple();
        expect(fetchedList, isNotNull);
        expect(fetchedList!.length, 10);
        for (int i=0 ; i<10 ; i++) {
          expect(fetchedList[i].name, createdList[i].name);
          expect(fetchedList[i].price, createdList[i].price);
        }
      }
  );

  test(
    'Add multiple then fetch all.',
      () async {
        // Add multiple items by DAO
        Batch b = (await mdc.db).batch();
        List<Item?> createdList = [];
        for (int i=0 ; i<10 ; i++) {
          Item t = Item(name: 'AFM Test Item $i', price: 3.22*i);
          Item? created = await sut.add(t);
          expect(created, isNotNull);
          createdList.add(created as Item);
        }
        await b.commit();
        // Fetch all items by DAO (the ones above)
        List<Item>? fetchedList = await sut.getMultiple();
        expect(fetchedList, isNotNull);
        expect(fetchedList!.length, 10);
        for (int i=0 ; i<10 ; i++) {
          expect(fetchedList[i], isNotNull);
          expect(fetchedList[i].id, createdList[i]!.id);
          expect(fetchedList[i].name, createdList[i]!.name);
          expect(fetchedList[i].price, createdList[i]!.price);
        }
      }
  );

  test(
    'Add multiple, then get multiple filtered by name.',
      () async {
        // Add multiple items by DAO with specific names
        List<String> names = ['Hot Potatoes', 'Cold Potato Salad', 'Hotdog', 'Coleslaw', 'Flaminhotcheetos', 'Croque Monsieur'];
        List<Item?> createdList = [];
        Batch b = (await mdc.db).batch();
        for (int i=0 ; i<6 ; i++) {
          Item t = Item(name: names[i], price: 3.22*i);
          Item? created = await sut.add(t);
          expect(created, isNotNull);
          createdList.add(created);
        }
        await b.commit();
        // Fetch filtered items that contain the 'hot' substring by DAO
        List<Item>? fetchedList = await sut.getMultiple(where: 'name LIKE ?', whereArgs: ['%hot%']);
        expect(fetchedList, isNotNull);
        expect(fetchedList!.length, 3);
        int j = 0;
        for (int i=0 ; i<3 ; i++) {
          expect(fetchedList[i], isNotNull);
          j = names.indexOf(fetchedList[i].name);
          expect(fetchedList[i].id, createdList[j]!.id);
          expect(fetchedList[i].price, createdList[j]!.price);
        }
      }
  );
}