
class Item {
  final int? id;
  final String name;
  final double price;

  Item({
    this.id,
    required this.name,
    required this.price,
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
  );

  Map<String, Object> toMap() => {'name': name, 'price': price};

  @override
  bool operator ==(Object other) => other is Item && id == other.id && name == other.name && price == other.price;

  @override
  int get hashCode => id.hashCode;

}