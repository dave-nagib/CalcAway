import 'package:flutter/material.dart';

class DrawerNavigator extends StatelessWidget {
  const DrawerNavigator({super.key});

  static const _entryFontSize = 23.0;
  static const _entryIconSize = 29.0;
  static const _entryEdgeInsets =
      EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0);
  static const _menuItems = ['Shop', 'Items', 'Receipts', 'About'];
  static const _icons = [
    Icons.shopping_cart_rounded,
    Icons.apps_rounded,
    Icons.receipt_long,
    Icons.info
  ];
  static const _routes = ['/shop', '/items', '/receipts', '/about'];

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 50.0,
        shadowColor: Colors.black,
        width: 225.0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        )),
        backgroundColor: const Color(0xFF202C39),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF202C39),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 30.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(AssetImage('assets/images/calcaway-logo.png'),
                      size: 75.0, color: Colors.white),
                  Text(
                    'CalcAway',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Saira',
                      fontWeight: FontWeight.w500,
                      fontSize: 32.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            ...List<int>.generate(_menuItems.length, (index) => index + 1)
                .map((i) => ListTile(
                      contentPadding: _entryEdgeInsets,
                      leading: Icon(_icons[i - 1], color: Colors.white, size: _entryIconSize),
                      title: Text(_menuItems[i - 1],
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Saira',
                              fontSize: _entryFontSize)),
                      onTap: () {
                        Navigator.pop(context); // Close the drawer first
                        if (ModalRoute.of(context)?.settings.name != _routes[i-1]) {
                          Navigator.pushReplacementNamed(context, _routes[i-1]);
                        }
                      },
                    )),
          ],
        ));
  }
}
