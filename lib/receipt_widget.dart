import 'package:flutter/material.dart';
import 'receipt.dart';

class ReceiptWidget extends StatelessWidget {
  final Receipt receipt;

  const ReceiptWidget({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD5B390),
      child: Column(
        children: [
          AppBar(
            toolbarHeight: 65.0,
            backgroundColor: const Color(0xFF3C2317),
            centerTitle: true,
            title: Text(
              'Total: ${receipt.totalCost()}',
              style: const TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 25.0),
            child: SizedBox(
              height: 350.0,
              child: ListView.builder(
                itemCount: receipt.nonZeroItems.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            receipt.nonZeroItems[index].name,
                            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${receipt.nonZeroItems[index].price} X ${receipt.nonZeroItems[index].count}',
                            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ),
            )
          )
        ]
      )
    );
  }
}
