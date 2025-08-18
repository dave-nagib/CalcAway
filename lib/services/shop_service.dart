import 'package:calc_away/data/models/item.dart';
import 'package:calc_away/data/models/receipt.dart';
import '../data/db/item_dao.dart';

class ShopService {
  // late List<Item> itemList;
  // bool errorFlag = false;
  // Map<int, int> _itemOrder = {};
  Receipt activeReceipt = Receipt();
  // int _inactiveItemsStart = 0;
  final ItemDAO itemDAO;

  ShopService(this.itemDAO);

  /// Fetch all items using the given sorting field and search filter, reorders them, then sets the final list.
  Future<List<Item>?> fetchItems(String searchBar, String orderBy, bool ascending) async {
    // Fetch items from the database using the given order and search filter
    return itemDAO.getMultiple(
      where: 'name LIKE ?',
      whereArgs: ['%$searchBar%'],
      sortBy: orderBy,
      ascending: ascending,
    );
    // If no items are found, set the error flag and return an empty list
    // if (items == null || items.isEmpty) {
    //   errorFlag = items == null;
    //   itemList = [];
    //   return;
    // } else {
    //   errorFlag = false;
    //   itemList = items;
    // }
    // Set new order key for each item
    // _itemOrder = {};
    // for (int i=0 ; i<items.length ; i++) {
    //   _itemOrder[items[i].id!] = i;
    // }
    // List<Item> inactiveItems = items.toList();
    // Remove active items from the list
    // inactiveItems.removeWhere((t) => activeReceipt.contains(t));
    // Obtain receipt items as a list
    // List<Item> activeItems = activeReceipt.items;
    // Sort active items list according to the orderKeys
    // activeItems.sort((a,b) => _itemOrder[a.id]!.compareTo(_itemOrder[b.id]!));
    // itemList = activeItems + inactiveItems;
  }

  bool addOneOf(Item t) => activeReceipt.addOneOf(t);
    // if (activeReceipt.addOneOf(itemList[itemIdx])) {
    //   // Remove item from the inactive items range
    //   Item relocated = itemList.removeAt(itemIdx);
    //   // Insert the item into the active items range
    //   int idx = _binarySearchInsert(_itemOrder[relocated]!, 0, _inactiveItemsStart);
    //   itemList.insert(idx, relocated);
    //   // Update the inactive items start
    //   _inactiveItemsStart++;
    //   return true;
    // }
    // return false;
  // }

  bool removeOneOf(Item t) => activeReceipt.removeOneOf(t);
  //   if (activeReceipt.removeOneOf(itemList[itemIdx])) {
  //     // Remove the item from the active items range and update the inactive items start
  //     Item relocated = itemList.removeAt(itemIdx);
  //     _inactiveItemsStart--;
  //     // Insert the item into the inactive items range
  //     int idx = _binarySearchInsert(_itemOrder[relocated]!, _inactiveItemsStart, itemList.length);
  //     itemList.insert(idx, relocated);
  //     return true;
  //   }
  //   return false;
  // }

  /// Inserts an item in O(log n) in the items list by using binary search between the `left` (inclusive) and `right` (exclusive) indexes.
  // int _binarySearchInsert(int itemKey, int left, int right) {
  //   if (left == right) {
  //     return left; // Base case - item goes at the very beginning or at the very end
  //   }
  //   int mid = (left + right) ~/ 2;
  //   int midKey = _itemOrder[itemList[mid]]!;
  //   // If the middle element is the last element, set the key after it to midKey + 1
  //   int nextToMidKey = (mid != itemList.length - 1)? _itemOrder[itemList[mid+1]]! : midKey + 1;
  //   // Check if position if found or where we should search next
  //   if ((midKey < itemKey && itemKey < nextToMidKey) || itemKey == midKey || itemKey == nextToMidKey) {
  //     return mid + 1; // Base case - item position found
  //   } else if (itemKey < midKey) {
  //     return _binarySearchInsert(itemKey, left, mid);
  //   } else {
  //     return _binarySearchInsert(itemKey, mid + 1, right);
  //   }
  // }

  /// Resets the current receipt to an empty one, pushing active items to their original order
  void resetReceipt() {
    // _inactiveItemsStart = 0;
    activeReceipt = Receipt();
    // itemList.sort((a,b) => _itemOrder[a.id]!.compareTo(_itemOrder[b.id]!));
  }


}