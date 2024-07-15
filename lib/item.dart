import 'dart:convert';

class Item {
  final String name;
  final double price;
  int count = 0;

  Item (this.name, this.price);

  factory Item.fromJson(dynamic obj){
    return Item(obj['name'] as String, obj['price'] as double);
  }

  String getJsonString() {
    return '{"name": "$name", "price": $price}';
  }

  bool addOne() {
    count++;
    return count == 1; // It will be newly added to receipt if it was zero
  }

  bool removeOne() {
    bool recRemove = false; // Used to indicate whether item will be removed or added to receipt
    if (count > 0) {
      recRemove = (count == 1);
      count--;
    }
    return recRemove;
  }

  double getCost() => count*price;
}