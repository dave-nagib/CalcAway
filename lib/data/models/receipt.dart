import 'item.dart';

class Receipt {

  final int? id;
  final DateTime? timestamp;
  final Map<Item,int> nonZeroItems;
  final Map<int, double> discounts;

  Receipt({
    this.id,
    this.timestamp,
    this.nonZeroItems = const {},
    this.discounts = const {},
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

  /// Updates the discount of an item by its ID (adding the discount if it does not exist).
  /// Returns false if the discount percentage is invalid (<= 0 or > 100).
  bool updateDiscount(int itemId, double discountPercentage) {
    if (discountPercentage <= 0 || discountPercentage > 100) return false;
    discounts[itemId] = discountPercentage;
    return true;
  }

  /// Removes the discount of an item from the receipt. Returns false if the discount did not exist, and true otherwise.
  bool removeDiscount(int itemId) {
    return discounts.remove(itemId) != null;
  }

  double get cost {
    double ret = 0.0, discountedPrice;
    for (var entry in nonZeroItems.entries) {
      discountedPrice = entry.key.price * (1 - (discounts[entry.key.id] ?? 0.0) / 100);
      ret += entry.value * discountedPrice;
    }
    return ret;
  }

  void reset() {
    nonZeroItems.clear();
    discounts.clear();
  }

}