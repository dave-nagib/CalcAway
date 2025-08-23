import 'package:calc_away/data/db/dev_database_connection.dart';
import 'package:calc_away/data/db/item_dao.dart';
import 'package:calc_away/data/db/receipt_dao.dart';
import 'package:calc_away/services/items_page_service.dart';
import 'package:calc_away/services/receipts_page_service.dart';
import 'package:calc_away/services/shop_service.dart';
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
      '/shop': (context) => ShopPage(shopService: ShopService(ItemDAO(DevDatabaseConnection()))),
      '/items': (context) => ItemsPage(itemService: ItemsPageService(ItemDAO(DevDatabaseConnection()))),
      '/receipts': (context) => ReceiptsPage(receiptsService: ReceiptsPageService(ReceiptDAO(DevDatabaseConnection()))),
      '/about': (context) => const AboutPage(),
    },
  ));
}