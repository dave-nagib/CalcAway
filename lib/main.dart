import 'package:flutter/material.dart';
import 'display/edit_list_dialog.dart';
import 'display/item_count_widget.dart';
import 'display/receipt_widget.dart';
import 'data/models/receipt.dart';
import 'item_list_manager.dart';


void main() {
  runApp(const MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

// Test items
// [
  // Item('yep definitely a book', 70),
  // Item('small book', 20),
  // Item('book that is on sale', 50),
  // Item('book with a really really extremely exquisitely very long title', 100),
  // Item('another book', 60),
  // Item('test book 1', 40),
  // Item('test book 2', 45),
  // Item('test book 3', 50),
  // Item('test book 4', 55),
  // Item('test book 5', 60),
  // Item('test book 6', 65),
  // Item('test book 7', 70),
  // Item('test book 8', 30),
  // Item('test book 9', 200)
// ]

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

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
      appBar: AppBar(
        toolbarHeight: 80.0,
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
                AssetImage('assets/images/calcaway-logo.png'),
                size: 40.0
            ),
            SizedBox(width: 7.5),
            Text(
              'CalcAway',
              style: TextStyle(
                fontSize: 45.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Saira'
              ),
            ),
          ]
        ),
        backgroundColor: const Color(0xff08090a),
      ),
      body: ListView.builder(
        itemCount: itemMgr.getItems().length,
        itemBuilder: (context, index) => ItemCountWidget(const Key(''), itemMgr.getItems()[index], mainReceipt),
      ),
      persistentFooterButtons: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
          child: FloatingActionButton(
            backgroundColor: const Color(0xff08090a),
            onPressed: () => showAdaptiveDialog(
              context: context,
              builder: (context) => EditListDialog(itemManager: itemMgr)
            ),
            child: const Icon(Icons.edit, color: Color(0xFFD9D9D9), size: 30.0)
          ),
        ), // Edit
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
          child: FloatingActionButton(
              backgroundColor: const Color(0xff08090a),
              onPressed: () => {
                setState(() => mainReceipt.reset())
              },
              child: const Icon(Icons.restart_alt, color: Color(0xFFD9D9D9), size: 35.0)
          ),
        ), // Reset/Rebuild
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
          child: FloatingActionButton(
              backgroundColor: const Color(0xff08090a),
              onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => ReceiptWidget(receipt: mainReceipt)
              ),
              child: const Icon(Icons.receipt, color: Color(0xFFD9D9D9), size: 30.0)
          ),
        ), // Receipt
      ],
      persistentFooterAlignment: AlignmentDirectional.bottomCenter,
    );
  }
}