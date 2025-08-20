import 'package:calc_away/data/models/item.dart';
import 'package:calc_away/display/helpers/flushbar_feedback.dart';
import 'package:calc_away/display/widgets/edit_item_dialog.dart';
import 'package:calc_away/services/items_page_service.dart';
import 'package:flutter/material.dart';
import 'confirmation_dialog.dart';

class ItemTile extends StatelessWidget {

  final (Item, int, double) itemData;
  final VoidCallback onChange; // For simplicity, we use a callback for all changes (addition, deletion, and updates)
  final ItemsPageService itemService;

  const ItemTile(this.itemData, this.onChange, {required this.itemService, super.key});

  @override
  Widget build(BuildContext context) {

    final item = itemData.$1;
    final unitsSold = itemData.$2;
    final discount = itemData.$3;

    return Card(
      elevation: 15.0,
      shadowColor: Colors.black,
      color: const Color(0xFF263445),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
      margin: const EdgeInsets.fromLTRB(12.0, 17.0, 12.0, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(22.5),
        child: Column(
          children: [
            Row( // Item name and price
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Saira',
                    ),
                  ),
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text( // Price
                        '£${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFFD9D9D9),
                          fontSize: 22.5,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Monaco',
                        ),
                      ),
                      discount == 0.0? const SizedBox() : const SizedBox(height: 7.0),
                      discount == 0.0
                        ? const SizedBox()
                        : Text( // Discount
                        '-${discount.toStringAsFixed(2)}%',
                        style: const TextStyle(
                          color: Color(0xFFFF724C),
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Monaco',
                        ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 65.0,
              child: Stack(
                children: [
                  Align( // Units sold
                    alignment: Alignment.topLeft,
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 22.0, fontFamily: 'Saira', fontWeight: FontWeight.w600),
                        children: [
                          const TextSpan(text: 'Units sold: ', style: TextStyle(color: Colors.white30)),
                          TextSpan(text: '$unitsSold', style: const TextStyle(color: Color(0xFFDEA756), letterSpacing: 2.0)),
                        ],
                      ),
                    ),
                  ),
                  Align( // Item ID
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      '${item.id!}',
                      style: const TextStyle(
                        color: Color(0xFFC6EBBE),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'courier',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton( // edit
                          heroTag: 'edit-${item.id}',
                          mini: true,
                          backgroundColor: const Color(0xFF31455A),
                          child: const Icon(Icons.edit_rounded, color: Color(0xFFD9D9D9), size: 25.0),
                          onPressed: () {
                            showDialog<bool>(
                              context: context,
                              builder: (context) => EditItemDialog(
                                item: item,
                                discount: discount,
                                itemService: itemService,
                              )
                            ).then((res) {
                              if (res != null && res) {
                                onChange();
                                showSuccessFlushbar(context, 'Item updated successfully.');
                              }
                            });
                          },
                        ),
                        FloatingActionButton( // discontinue
                          heroTag: 'discontinue-${item.id}',
                          mini: true,
                          backgroundColor: const Color(0xFF31455A),
                          child: const Icon(Icons.block, color: Color(0xFFD9D9D9), size: 25.0),
                          onPressed: () {
                            showDialog<bool>(
                                context: context,
                                builder: (context) => ConfirmationDialog(
                                  title: 'Confirm Discontinuation',
                                  content: 'Are you sure you want to discontinue this item? This action cannot be undone.',
                                  action: () => itemService.discontinueItem(item.id!),
                                )
                            ).then((answer) {
                              if (answer != null && answer) {
                                onChange();
                                showSuccessFlushbar(context, 'Item discontinued successfully.');
                              }
                            });
                          },
                        ),
                        FloatingActionButton( // delete
                          heroTag: 'delete-${item.id}',
                          mini: true,
                          backgroundColor: const Color(0xFF31455A),
                          child: const Icon(Icons.delete_rounded, color: Color(0xFFD9D9D9), size: 25.0),
                          onPressed: () {
                            showDialog<bool>(
                                context: context,
                                builder: (context) => ConfirmationDialog(
                                  title: 'Confirm Deletion',
                                  content: 'Are you sure you want to delete this item? This action cannot be undone.',
                                  action: () => itemService.deleteItem(item.id!),
                                )
                            ).then((answer) {
                              if (answer != null && answer) {
                                onChange();
                                showSuccessFlushbar(context, 'Item discontinued successfully.');
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
