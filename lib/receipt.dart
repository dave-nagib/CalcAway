import 'item.dart';

class Receipt {

  final int? id;
  final DateTime? timestamp;
  final Map<Item,int> nonZeroItems;

  Receipt({
    this.id,
    this.timestamp,
    this.nonZeroItems = const {}
  });

  /// Returns true for newly added items and false for items that were already in the receipt.
  bool addOneOf(Item t) {
    int count = nonZeroItems.update(t, (v) => v+1, ifAbsent: () => 1);
    return count == 1; // It will be newly added to receipt if its new count is 1
  }

  /// Returns true if the item will be completely removed from the receipt and false if it is already 0.
  bool removeOneOf(Item t) {
    int count = nonZeroItems[t] ?? 0;
    if (count == 1) {
      nonZeroItems.remove(t);
      return true;
    } else if (count > 0) {
      nonZeroItems.update(t, (v) => v-1);
    }
    return false; // Reaching this point means that count is 0 or greater than 1
  }

  double get cost {
    double ret = 0.0;
    for (var entry in nonZeroItems.entries) {ret += entry.key.price * entry.value;}
    return ret;
  }

  void reset() {
    nonZeroItems.clear();
  }

}