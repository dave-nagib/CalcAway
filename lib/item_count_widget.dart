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

  Color? getCountColor (int count) => (count == 0)? const Color(0xff253b3d) : const Color(0xffC6EBBE);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7.5,
      shadowColor: Colors.black,
      color: const Color(0xFF08090A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      margin: const EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20.0, 40.0, 10.0, 40.0),
            width: 170.0,
            child: Text(
              widget.item.name,
              style: const TextStyle(
                color: Color(0xffD9D9D9),
                fontSize: 23.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'REM'
              ),
            ),
          ),
          Container(
            width: 175.0,
            padding: const EdgeInsets.only(right: 17.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 53.0,
                  child: FloatingActionButton( // THE SUBTRACT BUTTON
                    onPressed: () => {
                      setState(() => {
                        if(widget.item.removeOne()) widget.receipt.removeFromReceipt(widget.item)
                      })
                    },
                    backgroundColor: const Color(0xFF730C0C),
                    child: const Text(
                      '-',
                      style: TextStyle(
                        fontSize: 35.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                Text(
                  '${widget.item.count}',
                  style: TextStyle(
                    color: getCountColor(widget.item.count),
                    fontFamily: 'Saira',
                    fontSize: 43.0,
                    fontWeight: FontWeight.w800
                  ),
                ),
                SizedBox(
                  width: 53.0,
                  child: FloatingActionButton( // THE ADD BUTTON
                    onPressed: () => {
                      setState(() => {
                        if(widget.item.addOne()) widget.receipt.addToReceipt(widget.item)
                      })
                    },
                    backgroundColor: const Color(0xFF38482C),
                    child: const Text(
                      '+',
                      style: TextStyle(
                          fontSize: 35.0,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
