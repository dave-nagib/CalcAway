import 'package:calc_away/data/models/receipt.dart';
import 'package:calc_away/display/widgets/confirmation_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ReceiptExpansionTile extends StatefulWidget {
  final Receipt receipt;
  final AsyncValueGetter<Receipt> getReceiptData;
  final VoidCallback onDelete;

  const ReceiptExpansionTile(this.receipt, this.getReceiptData, this.onDelete, {super.key});
  static const receiptStyle = TextStyle(
    color: Color(0xffC6D0CD),
    fontFamily: 'Monaco',
    fontSize: 15.0,
    fontWeight: FontWeight.w800,
  );

  @override
  State<ReceiptExpansionTile> createState() => _ReceiptExpansionTileState();
}

class _ReceiptExpansionTileState extends State<ReceiptExpansionTile> {

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      shadowColor: Colors.black,
      color: const Color(0xFF1C2022),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
      margin: const EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 0.0),
      child: ExpansionTile(
        collapsedIconColor: Colors.white54,
        iconColor: Colors.white,
        tilePadding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 7.5),
        title: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontFamily: 'Saira',
              fontSize: 22.5,
              letterSpacing: 1.0,
            ),
            children: [
              const TextSpan(text: 'ID:  ', style: TextStyle(color: Colors.white54)),
              TextSpan(text: '${widget.receipt.id}', style: const TextStyle(color: Color(0xFFC6FFEE), fontWeight: FontWeight.w600, letterSpacing: 2.5)),
            ],
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
              DateFormat('dd/MM/yyyy, h:mm a').format(widget.receipt.timestamp!),
              style: ReceiptExpansionTile.receiptStyle,
          ),
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            if (!expanded) {
              widget.receipt.clearItems();
            }
            _expanded = expanded;
          });
        },
        childrenPadding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
        children: [
          _expanded
           ? FutureBuilder(
              future: _loadExpandedContent(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: CircularProgressIndicator(color: Color(0xFFC6FFEE), strokeWidth: 6.0),
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No items found.'));
                } else {
                  return Column(children: snapshot.data!);
                }
              }
          )
          : const SizedBox.shrink(),
        ]
      ),
    );
  }

  Future<List<Widget>> _loadExpandedContent() async {
    Receipt fetched = await widget.getReceiptData();
    widget.receipt.nonZeroItems.addAll(fetched.nonZeroItems);
    widget.receipt.discounts.addAll(fetched.discounts);
    return [
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Spacer(flex: 2),
                Expanded(flex: 13, child: Text('Item', style: ReceiptExpansionTile.receiptStyle,)),
                Spacer(flex: 1),
                Expanded(flex: 6, child: Text('Price', style: ReceiptExpansionTile.receiptStyle,)),
                Spacer(flex: 1),
                Expanded(flex: 5, child: Text('Qty', style: ReceiptExpansionTile.receiptStyle,)),
                Spacer(flex: 1),
              ],
            ),
            ...widget.receipt.nonZeroItems.entries.map((entry) => Container(
              decoration: BoxDecoration(
                color: const Color(0xFF111315),
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.only(top: 7.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(flex: 2),
                        Expanded(flex: 13, child: Text(entry.key.name, style: ReceiptExpansionTile.receiptStyle)),
                        const Spacer(flex: 1),
                        Expanded(flex: 6, child: Text(entry.key.price.toStringAsFixed(2), style: ReceiptExpansionTile.receiptStyle)),
                        const Spacer(flex: 1),
                        Expanded(flex: 5, child: Text('${entry.value}', style: ReceiptExpansionTile.receiptStyle)),
                        const Spacer(flex: 1),
                      ],
                    ),
                    (() {
                      final discount = widget.receipt.discounts[entry.key.id];
                      return discount != null
                          ? Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            const Spacer(flex: 5),
                            Expanded(flex: 10, child: Text('Dsc. %$discount', style: ReceiptExpansionTile.receiptStyle)),
                            const Spacer(flex: 1),
                            Expanded(flex: 6, child: Text('-${(entry.key.price * discount / 100).toStringAsFixed(2)}', style: ReceiptExpansionTile.receiptStyle)),
                            const Spacer(flex: 7),
                          ],
                        ),
                      )
                          : const SizedBox();
                    })(),
                  ],
                ),
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(top: 9.0),
              child: Row(
                children: [
                  const Spacer(flex: 2),
                  const Expanded(flex: 13, child: Text('Total', style: ReceiptExpansionTile.receiptStyle)),
                  const Spacer(flex: 1),
                  Expanded(flex: 6, child: Text(widget.receipt.cost.toStringAsFixed(2), style: ReceiptExpansionTile.receiptStyle)),
                  Expanded(
                    flex: 7,
                    child: FloatingActionButton( // delete
                      heroTag: UniqueKey(),
                      mini: true,
                      backgroundColor: const Color(0xD7460909),
                      child: const Icon(Icons.delete_rounded, color: Colors.white54, size: 25.0),
                      onPressed: () async {
                        bool? answer = await showDialog<bool>(
                            context: context,
                            builder: (context) => const ConfirmationDialog(
                              title: 'Confirm Deletion',
                              content: 'Are you sure you want to delete this receipt? This action cannot be undone.',
                            )
                        );
                        if (answer != null && answer) {
                          widget.onDelete();
                          // TODO receipt deletion flushbar
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ]
      ),
    ];
  }

}
