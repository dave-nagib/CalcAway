import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'item.dart';

class ItemListManager {

  List<Item> items = [];

  void writeItems() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList('items', items.map((item) => item.getJsonString()).toList());
  }

  void readItems() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? itemsJson = pref.getStringList('items');
    if (itemsJson != null){
      items = itemsJson
          .map( (str) => jsonDecode(str) ).toList()
          .map( (dyn) => Item.fromJson(dyn) ).toList();
    }else{
      items = [
        Item('Item fetching', 30),
        Item('Failed', 40)
      ];
    }
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
      items.add(Item(name, price));
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