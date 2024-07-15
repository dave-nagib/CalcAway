import 'package:flutter/material.dart';
import 'item.dart';
import 'receipt.dart';

class ItemCountWidget extends StatefulWidget {
  Item item;
  Receipt receipt;
  ItemCountWidget(Key key, this.item, this.receipt) : super(key: key);
  @override
  State<ItemCountWidget> createState() => _ItemCountWidgetState();
}

class _ItemCountWidgetState extends State<ItemCountWidget> {

  Color? getCountColor (int count) => (count == 0)? const Color(0xFFAB8F73) : const Color(0xff321E1E);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7.5,
      shadowColor: Colors.black,
      color: const Color(0xFFD5B390),
      margin: const EdgeInsets.fromLTRB(15.0, 18.0, 15.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 40.0),
            width: 170.0,
            child: Text(
              widget.item.name,
              style: const TextStyle(
                color: Color(0xff021927),
                fontSize: 19.0,
                fontWeight: FontWeight.w800,
                fontFamily: 'Dinarone'
              ),
            ),
          ),
          FloatingActionButton( // THE SUBTRACT BUTTON
            onPressed: () => {
              setState(() => {
                if(widget.item.removeOne()) widget.receipt.removeFromReceipt(widget.item)
              })
            },
            backgroundColor: const Color(0xFF9B1212),
            child: const Text(
              '-',
              style: TextStyle(
                fontSize: 35.0,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Text(
            '${widget.item.count}',
            style: TextStyle(
              color: getCountColor(widget.item.count),
              fontSize: 43.0,
              fontWeight: FontWeight.w700
            ),
          ),
          FloatingActionButton( // THE ADD BUTTON
            onPressed: () => {
              setState(() => {
                if(widget.item.addOne()) widget.receipt.addToReceipt(widget.item)
              })
            },
            backgroundColor: const Color(0xFF435334),
            child: const Text(
              '+',
              style: TextStyle(
                  fontSize: 35.0,
                  color: Colors.white
              ),
            ),
          ),
        ],
      ),
    );
  }
}
