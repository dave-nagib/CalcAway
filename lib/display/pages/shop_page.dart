import 'package:flutter/material.dart';
import 'package:calc_away/data/models/receipt.dart';
import 'package:calc_away/item_list_manager.dart';
import 'package:calc_away/display/widgets/calcaway_app_bar.dart';
import 'package:calc_away/display/widgets/item_count_tile.dart';
import 'package:calc_away/display/widgets/search_sort_bar.dart';
import 'package:calc_away/display/widgets/drawer_navigator.dart';

import '../../data/models/item.dart';
import 'checkout_page.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  Receipt mainReceipt = Receipt();
  final ItemListManager itemMgr = ItemListManager();

  @override
  void initState(){
    itemMgr.readItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202C39),
      appBar: const CalcawayAppBar(),
      drawer: const DrawerNavigator(),
      body: Stack(
        children: [
          Positioned.fill(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 70.0),
              itemCount: itemMgr.getItems().length,
              itemBuilder: (context, index) {
                Item item = itemMgr.getItems()[index];
                return ItemCountTile(item, mainReceipt, () => print('Activation changed'));
              },
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
      persistentFooterButtons: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
          child: FloatingActionButton(
            heroTag: UniqueKey(),
            backgroundColor: const Color(0xFF08090A),
            onPressed: () => setState(() => mainReceipt.clearItems()),
            child: const Icon(Icons.restart_alt_rounded, color: Color(0xFFD9D9D9), size: 35.0)
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
          child: FloatingActionButton(
              heroTag: UniqueKey(),
              backgroundColor: const Color(0xFF08090A),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      // TODO replace conditional block below with actual discount lookup
                      if (mainReceipt.items.length >= 2) {
                        mainReceipt.updateDiscount(mainReceipt.items[0].id!, 20.0);
                        mainReceipt.updateDiscount(mainReceipt.items[1].id!, 33.0);
                      }
                      return CheckoutPage(receipt: mainReceipt);
                    }
                ));
              },
              child: const Icon(Icons.shopping_cart_checkout_rounded, color: Color(0xFFD9D9D9), size: 30.0)
          ),
        ),
      ],
      persistentFooterAlignment: AlignmentDirectional.bottomCenter,
    );
  }
}