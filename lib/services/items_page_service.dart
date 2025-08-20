import 'package:calc_away/data/db/item_dao.dart';
import '../data/models/item.dart';

class ItemsPageService {
  ItemDAO itemDAO;
  static const maxNameLength = 50;
  static const minNameLength = 4;

  ItemsPageService(this.itemDAO);

  /// Adds a new item to the database. The passed name and price are guaranteed to be valid. Returns a string with status.
  Future<bool> addItem(String name, String price, String dsc) async {
    double parsedPrice = double.tryParse(price)!;
    Item? added = await itemDAO.add(
      Item(name: name, price: parsedPrice),
      discount: double.tryParse(dsc)
    );
    return added != null;
  }

  bool readItemsCSV(String filepath) {
    // TODO implement reading items from CSV file and add them to the database
    return false; // Placeholder return value
  }

  /// Updates an item's name or price. New changes will not reflect on past receipts.
  /// The item passed is guaranteed to have a valid name and price, which are different from previous values.
  Future<bool> updateItem(int id, String name, String price, String dsc) async {
    final item = Item(
      id: id,
      name: name,
      price: double.tryParse(price)!,
    );
    return await itemDAO.update(item, discount: double.tryParse(dsc)) > 0;
  }

  /// Discontinues an item.
  Future<bool> discontinueItem(int id) async {
    return await itemDAO.discontinue(id) > 0;
  }

  /// Deletes an item.
  Future<bool> deleteItem(int id) async {
    return await itemDAO.delete(id) > 0;
  }

  String? nameValidator(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name cannot be empty.';
    }
    if (name.length < minNameLength || name.length > maxNameLength) {
      return 'Name must be between $minNameLength and $maxNameLength characters long.';
    }
    if (!RegExp(r'^([\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFFa-zA-Z0-9-] ?)+$').hasMatch(name)) {
      return 'Name must only contain English or Arabic characters, numbers, or a hyphen -. Each word can only be separated by a single space.';
    }
    bool validName = false;
    itemDAO.nameAvailable(name).then((value) => {validName = value});
    if (!validName) {
      return 'Name is not available.';
    }
    return null;
  }

  String? priceValidator(String? price) {
    if (price == null || price.isEmpty) {
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

  String? discountValidator(String? discount) {
    if (discount == null || discount.isEmpty) { // Discount is optional
      return null;
    }
    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(discount)) {
      return 'Discount must be a positive percentage with up to two decimal places.';
    }
    double parsedDiscount = double.tryParse(discount)!;
    if (parsedDiscount <= 0.0 || parsedDiscount > 100.0) {
      return 'Discount must be greater than 0 and less or equal to 100.';
    }
    return null;
  }

  /// Fetches a list of named tuples (item, sold count, discount) from database filtered based on:
  /// - [searchBar] : string written in the search bar for filtering by name.
  /// - [orderBy] : string to order the results by. 'name', 'price', or 'popularity'.
  /// - [discontinuedSetting] : 0 to hide discontinued items, 1 to show only discontinued items, and anything else to show all.
  Future<List<(Item item, int soldCount, double discount)>?> fetchItemTuples(String? searchBar, String orderBy, bool ascending, {int discontinuedSetting = 0}) async {
    String discontinuedStr = switch (discontinuedSetting) {
      0 => 'AND discontinued = 0', // Not discontinued
      1 => 'AND discontinued = 1', // Discontinued
      _ => '' // All items
    };
    final itemsList = await itemDAO.getMultiple(
        where: 'name LIKE ? $discontinuedStr',
        whereArgs: ['%${searchBar ?? ''}%'],
        sortBy: orderBy,
        ascending: ascending
    );
    if (itemsList == null) {return null;}
    final ids = itemsList.map((t) => t.id!);
    final soldCounts = await itemDAO.saleCounts(ids);
    final discounts = await itemDAO.getDiscounts(ids);
    List<(Item item, int soldCount, double discount)> itemTuples = [];
    for (final item in itemsList) {
      itemTuples.add((item, soldCounts[item.id]!, discounts[item.id] ?? 0.0));
    }
    return itemTuples;
  }
}