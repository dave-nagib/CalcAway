import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/models/item.dart';

class ItemListManager {

  List<Item> items = [];

  void writeItems() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList('items', items.map((item) => item.getJsonString()).toList());
  }

  void readItems() async {
    items = [
      Item(id: 12, name: 'Viva La Vida or Death and All His Friends', price: 30),
      Item(id: 34, name: 'Parachutes', price: 40),
      Item(id: 56, name: 'X & Y', price: 50),
      Item(id: 78, name: 'A Rush of Blood to the Head', price: 2000),
      Item(id: 91, name: 'Everyday Life', price: 60),
      Item(id: 15, name: 'Ghost Stories', price: 45),
      Item(id: 16, name: 'A Head Full of Dreams', price: 30),
      Item(id: 17, name: 'Moon Music', price: 20)
    ];
  }

  List<Item> getItems() => items;

  bool addItem(String name, double price) {
    bool found = false;
    for (Item item in items) {
      if(item.name == name) {
        found = true;
        break;
      }
    }
    if(found || price <= 0) {
      return false;
    }else{
      items.add(Item(name: name, price: price));
    }
    writeItems();
    return true;
  }

  bool removeItem(String name) {
    for (Item item in items) {
      if(item.name == name) {
        items.remove(item);
        writeItems();
        return true;
      }
    }
    return false;
  }

}