import 'package:calc_away/display/widgets/add_item_dialog.dart';
import 'package:calc_away/display/widgets/item_tile.dart';
import 'package:flutter/material.dart';

import '../../data/models/item.dart';
import '../widgets/calcaway_app_bar.dart';
import '../widgets/drawer_navigator.dart';
import '../widgets/search_sort_bar.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {

  List<Item> items = [
    // Example items, replace with actual data
    Item(id: 123456, name: 'A REALLY LONG ITEM NAME THAT I HOPE DOES NOT OVERFLOW BECAUSE I WOULD HAVE TO CODE A LOT', price: 10.0),
    Item(id: 234567, name: 'Item 2', price: 20.0),
    Item(id: 345678, name: 'Item 3', price: 30.0),
  ]; // Assuming Item is a model class for items
  List<double> discounts = [10.0, 0.0, 12.0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF18212A),
      appBar: const CalcawayAppBar(),
      drawer: const DrawerNavigator(),
      body: Stack(
        children: [
          Positioned.fill(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 80.0),
              itemCount: items.length,
              itemBuilder: (context, index) => ItemTile(items[index], discounts[index], 23, () => print("changed")),
            ),
          ),
          const Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: SearchSortBar(),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 70.0,
        height: 70.0,
        child: FloatingActionButton(
          heroTag: 'add-item',
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AddItemDialog()
            );
          },
          backgroundColor: const Color(0xFFC4E8DD),
          foregroundColor: const Color(0xFF08090A),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
