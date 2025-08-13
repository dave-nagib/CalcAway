import 'package:flutter/material.dart';

class CalcawayAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CalcawayAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF08090A),
      automaticallyImplyLeading: false,
      toolbarHeight: 80.0,
      centerTitle: true,
      title: Stack(
        children: [
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ImageIcon(AssetImage('assets/images/calcaway-logo.png'), size: 40.0),
            SizedBox(width: 7.5),
            Text(
              'CalcAway',
              style: TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Saira'),
            ),
          ]),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.menu, size: 30.0),
                hoverColor: Colors.white.withOpacity(0.7),
                onPressed: () => Scaffold.of(context).openDrawer(),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(80.0);
  }
}
