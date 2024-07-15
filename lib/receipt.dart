import 'item.dart';

class Receipt {
  List<Item> nonZeroItems = [];

  void addToReceipt (Item something) {
    nonZeroItems.add(something);
  }

  void removeFromReceipt (Item something) {
    nonZeroItems.remove(something);
  }

  double totalCost() {
    double ret = 0.0;
    for (Item item in nonZeroItems) {ret += item.getCost();}
    return ret;
  }

  void reset() {
    for (Item item in nonZeroItems) {item.count = 0;}
    nonZeroItems.clear();
  }
}