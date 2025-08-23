import 'package:calc_away/data/db/receipt_dao.dart';
import 'package:calc_away/display/helpers/flushbar_feedback.dart';
import 'package:calc_away/services/checkout_service.dart';
import 'package:calc_away/services/shop_service.dart';
import 'package:flutter/material.dart';
import 'package:calc_away/data/models/receipt.dart';
import 'package:calc_away/display/widgets/calcaway_app_bar.dart';
import 'package:calc_away/display/widgets/item_count_tile.dart';
import 'package:calc_away/display/widgets/search_sort_bar.dart';
import 'package:calc_away/display/widgets/drawer_navigator.dart';
import '../../data/models/item.dart';
import 'checkout_page.dart';

class ShopPage extends StatefulWidget {
  final ShopService shopService;

  const ShopPage({required this.shopService, super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();

  CheckoutService get derivedCheckoutService {
    return CheckoutService(
      shopService.activeReceipt,
      ReceiptDAO(shopService.itemDAO.databaseConnection),
      shopService.itemDAO
    );
  }
}

class _ShopPageState extends State<ShopPage> {

  late Future<List<Item>?> _itemsFuture; // Cached future to avoid unnecessary DB fetches on each rebuild

  @override
  void initState() {
    super.initState();
    _itemsFuture = widget.shopService.fetchItems('', 'name', true);
  }

  void _refreshItems(String searchBar, String sortBy, bool ascending) {
    setState(() {
      _itemsFuture = widget.shopService.fetchItems(searchBar, sortBy, ascending);
    });
  }

  @override
  Widget build(BuildContext context) {

    Receipt activeReceipt = widget.shopService.activeReceipt;
    return Scaffold(
      backgroundColor: const Color(0xFF202C39),
      appBar: const CalcawayAppBar(),
      drawer: const DrawerNavigator(),
      body: Stack(
        children: [
          FutureBuilder<List<Item>?>(
            future: _itemsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFC6FFEE), strokeWidth: 4.0));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) { // TODO handle null vs empty
                return const Center(child: Text('No items found.'));
              }
              List<Item> items = snapshot.data!;
              return Positioned.fill(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 70.0),
                  itemCount: items.length,
                  itemBuilder: (context, index) => ItemCountTile(items[index], activeReceipt, widget.shopService)
                ),
              );
            }
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: SearchSortBar(onChanged: _refreshItems),
          ),
        ],
      ),
      persistentFooterButtons: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
          child: FloatingActionButton(
            heroTag: 'reset_receipt',
            backgroundColor: const Color(0xFF08090A),
            onPressed: () => setState(() => widget.shopService.resetReceipt()),
            child: const Icon(Icons.restart_alt_rounded, color: Color(0xFFD9D9D9), size: 35.0)
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
          child: FloatingActionButton(
              heroTag: 'checkout',
              backgroundColor: const Color(0xFF08090A),
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(
                    builder: (context) => CheckoutPage(checkoutService: widget.derivedCheckoutService)
                )).then((checkoutSuccess) {
                  if (checkoutSuccess ?? false) {
                    setState(() => widget.shopService.resetReceipt());
                    showSuccessFlushbar(context, 'Checkout successful.');
                  }
                });
              },
              child: const Icon(Icons.shopping_cart_checkout_rounded, color: Color(0xFFD9D9D9), size: 30.0)
          ),
        ),
      ],
      persistentFooterAlignment: AlignmentDirectional.bottomCenter,
    );
  }
}