import 'package:calc_away/data/db/item_dao.dart';

import '../data/models/item.dart';

class ItemService {
  ItemDAO itemDAO;
  static const maxNameLength = 50;
  static const minNameLength = 3;

  ItemService(this.itemDAO);

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
    if (!RegExp(r'^[a-zA-Z0-9-]+$').hasMatch(name)) {
      return 'Name must only contain English characters, numbers, or a hyphen -.';
    }
    return null;
  }

  String? priceValidator(String price) {
    if (price.isEmpty) {
      return 'Price cannot be empty.';
    }
    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(price)) {
      return 'Price must be a number with up to two decimal places.';
    }
    return null;
  }

  Future<List<Item>?> fetchCurrentItems(String searchBar, String orderBy) async {
    return itemDAO.getMultiple(where: 'discontinued = ? AND name LIKE ?', whereArgs: ['0', '%$searchBar%'], sortBy: orderBy);
  }

  Future<List<Item>?> fetchDiscontinued(String searchBar, String orderBy) async {
    return itemDAO.getMultiple(where: 'discontinued = ? AND name LIKE ?', whereArgs: ['1', '%$searchBar%'], sortBy: orderBy);
  }

  Future<List<Item>?> fetchAllItems(String searchBar, String orderBy) async {
    return itemDAO.getMultiple(where: 'name LIKE ?', whereArgs: ['%$searchBar%'], sortBy: orderBy);
  }
}
