import 'package:calc_away/data/models/receipt.dart';
import 'package:flutter/material.dart';
import '../../data/models/item.dart';
import '../widgets/drawer_navigator.dart';
import '../widgets/receipt_expansion_tile.dart';
import '../widgets/calcaway_app_bar.dart';

class ReceiptsPage extends StatelessWidget {
  const ReceiptsPage({super.key});

  List<Receipt> getSampleReceiptList() =>  [
      Receipt(id: 123456, timestamp: DateTime(2023, 10, 1, 12, 30), nonZeroItems: {Item(id: 1, name: 'Some item', price: 32.0): 3, Item(id: 3, name: 'An item with a really very extremely long name that I hope does not cause a problem', price: 30.0): 4}, discounts: {1: 20, 3: 50}),
      Receipt(id: 234567, timestamp: DateTime(2022, 12, 12, 13, 25), nonZeroItems: {}, discounts: {}),
      Receipt(id: 345678, timestamp: DateTime(2002, 8, 2, 18, 0), nonZeroItems: {}, discounts: {}),
      Receipt(id: 456789, timestamp: DateTime(2018, 4, 16, 9, 30), nonZeroItems: {}, discounts: {}),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1419),
      appBar: const CalcawayAppBar(),
      drawer: const DrawerNavigator(),
      body: ListView.builder(
        itemCount: getSampleReceiptList().length,
        itemBuilder: (context, index) => ReceiptExpansionTile(
            getSampleReceiptList()[index],
            () async {
              await Future.delayed(const Duration(seconds: 1));
              return getSampleReceiptList()[0];
            },
            () => print("Delete receipt with id ${getSampleReceiptList()[index].id}")
        ),
      ),
    );
  }
}
