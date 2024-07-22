
class Item {
  final int? id;
  final String name;
  final double price;
  int count = 0;

  Item({
    this.id,
    required this.name,
    required this.price,
    this.count = 0,
  });

  // TODO delete this
  factory Item.fromJson(dynamic obj){
    return Item(name: obj['name'] as String, price: obj['price'] as double);
  }

  // TODO delete this
  String getJsonString() {
    return '{"name": "$name", "price": $price}';
  }

  factory Item.fromMap(Map<String,Object?> map) => Item(
      id: map['id'] as int,
      name: map['name'] as String,
      price: map['price'] as double,
      count: map['count'] as int? ?? 0
  );

  Map<String, Object> toMap() => {'name': name, 'price': price};

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