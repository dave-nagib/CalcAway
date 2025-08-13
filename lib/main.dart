import 'display/pages/about_page.dart';
import 'display/pages/items_page.dart';
import 'display/pages/receipts_page.dart';
import 'display/pages/shop_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/shop',
    routes: {
      '/shop': (context) => const ShopPage(),
      '/items': (context) => const ItemsPage(),
      '/receipts': (context) => const ReceiptsPage(),
      '/about': (context) => const AboutPage(),
    },
  ));
}