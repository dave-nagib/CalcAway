import 'package:calc_away/data/db/item_dao.dart';
import 'package:calc_away/data/db/receipt_dao.dart';
import '../data/models/item.dart';

class ItemsPageService {
  ItemDAO itemDAO;
  ReceiptDAO receiptDAO;
  static const maxNameLength = 50;
  static const minNameLength = 3;

  ItemsPageService(this.itemDAO, this.receiptDAO);

  /// Adds a new item to the database. The passed name and price are guaranteed to be valid. Returns a string with status.
  Future<String> addItem(String name, String price) async {
    double parsedPrice = double.tryParse(price)!;
    Item? added = await itemDAO.add(Item(name: name, price: parsedPrice));
    if (added == null) {
      return 'Failed to add item.';
    }
    return 'Item added successfully.';
  }

  bool readItemsCSV(String filepath) {
    // TODO implement reading items from CSV file and add them to the database
    return false; // Placeholder return value
  }

  /// Updates an item's name or price. New changes will not reflect on past receipts.
  /// The item passed is guaranteed to have a valid name and price, which are different from previous values.
  Future<String> updateItem(Item item) async {
    if (await itemDAO.update(item) < 1) {
      return 'Failed to update item.';
    }
    return 'Item updated successfully.';
  }

  /// Discontinues an item.
  Future<String> discontinueItem(int id) async {
    if (await itemDAO.discontinue(id) < 1) {
      return 'Failed to discontinue item.';
    }
    return 'Item discontinued successfully.';
  }

  /// Deletes an item.
  Future<String> deleteItem(int id) async {
    if (await itemDAO.delete(id) < 1) {
      return 'Failed to delete item.';
    }
    return 'Item deleted successfully.';
  }

  String? nameValidator(String name) {
    if (name.isEmpty) {
      return 'Name cannot be empty.';
    }
    if (name.length < minNameLength || name.length > maxNameLength) {
      return 'Name must be between $minNameLength and $maxNameLength characters long.';
    }
    bool validName = false;
    itemDAO.nameAvailable(name).then((value) => {validName = value});
    if (!validName) {
      return 'Name is not available.';
    }
    if (!RegExp(r'^([\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFFa-zA-Z0-9-] ?)+$').hasMatch(name)) {
      return 'Name must only contain English or Arabic characters, numbers, or a hyphen -. Each word can only be separated by a single space.';
    }
    return null;
  }

  String? priceValidator(String price) {
    if (price.isEmpty) {
      return 'Price cannot be empty.';
    }
    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(price)) {
      return 'Price must be a positive number with up to two decimal places.';
    }
    if (double.tryParse(price)! <= 0.0) {
      return 'Price must be greater than 0.';
    }
    return null;
  }

  /// Fetches items from database filtered based on:
  /// - [searchBar] : string written in the search bar for filtering by name.
  /// - [orderBy] : string to order the results by. 'name', 'price', or 'popularity'.
  /// - [discontinuedSetting] : 0 to hide discontinued items, 1 to show only discontinued items, and anything else to show all.
  Future<List<Item>?> fetchItems(String searchBar, String orderBy, int discontinuedSetting) async {
    String discontinuedStr = switch (discontinuedSetting) {
      0 => 'AND discontinued = 0', // Not discontinued
      1 => 'AND discontinued = 1', // Discontinued
      _ => '' // All items
    };
    return itemDAO.getMultiple(
        where: 'name LIKE ? $discontinuedStr',
        whereArgs: ['%$searchBar%'],
        sortBy: orderBy
    );
  }
}