import 'package:calc_away/services/shop_service.dart';
import 'package:flutter/material.dart';
import '../../data/models/item.dart';
import '../../data/models/receipt.dart';

class ItemCountTile extends StatelessWidget {
  final Item _item;
  final Receipt _receipt;
  final ShopService shopService;

  const ItemCountTile(this._item, this._receipt, this.shopService, {super.key});

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
            padding: const EdgeInsets.fromLTRB(22.0, 30.0, 10.0, 30.0),
            width: 170.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _item.name,
                  style: const TextStyle(
                    color: Color(0xffD9D9D9),
                    fontSize: 23.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'REM'
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 9.0),
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161e27),
                    border: Border.all(color: const Color(0xFFB1E1D2), width: 1.0),
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Text(
                    '£${_item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFFC6FFEE),
                      fontSize: 16.5,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Monaco'
                    )
                  ),
                ),
              ],
            ),
          ),
          _CounterContainer(
            _item,
            _receipt,
            () => shopService.addOneOf(_item), // The add function
            () => shopService.removeOneOf(_item) // The subtract function
          ), // The counter widget
        ],
      ),
    );
  }
}

class _CounterContainer extends StatefulWidget {

  final Item _item;
  final Receipt _receipt;
  final VoidCallback _onAdd;
  final VoidCallback _onSubtract;

  const _CounterContainer(this._item, this._receipt, this._onAdd, this._onSubtract);

  @override
  State<_CounterContainer> createState() => _CounterContainerState();
}

class _CounterContainerState extends State<_CounterContainer> {

  Color? _getCountColor () => (widget._receipt.getCountOf(widget._item) == 0)? const Color(0xff253b3d) : const Color(0xffC6EBBE);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175.0,
      padding: const EdgeInsets.only(right: 17.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 53.0,
            child: FloatingActionButton( // THE SUBTRACT BUTTON
              heroTag: UniqueKey(),
              onPressed: () => setState(() => widget._onSubtract()),
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
            '${widget._receipt.getCountOf(widget._item)}',
            style: TextStyle(
                color: _getCountColor(),
                fontFamily: 'Saira',
                fontSize: 43.0,
                fontWeight: FontWeight.w800
            ),
          ),
          SizedBox(
            width: 53.0,
            child: FloatingActionButton( // THE ADD BUTTON
              heroTag: UniqueKey(),
              onPressed: () => setState(() => widget._onAdd()),
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
    );
  }
}

