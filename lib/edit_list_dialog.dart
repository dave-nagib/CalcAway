import 'package:flutter/material.dart';
import 'item.dart';
import 'item_list_manager.dart';

class EditListDialog extends StatelessWidget {
  final ItemListManager itemManager;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  EditListDialog({super.key, required this.itemManager});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: const Color(0xFFFAEDCD),
      title: const Center(child: Text('Add/Remove Items')),
      titleTextStyle: const TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      content: SizedBox(
        height: 130.0,
        child: Column(
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(
                  labelText: 'Name of the item'
              ),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Price of the item'
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              String inName = nameController.text;
              if(inName != '' && itemManager.removeItem(inName)){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Item deleted successfully.',
                      style: TextStyle(fontSize: 20.0)
                    )
                  )
                );
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                      'Error: Item does not exist.',
                      style: TextStyle(fontSize: 20.0)
                    )
                  )
                );
              }
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              fixedSize: const Size(75.0, 45.0),
              foregroundColor: const Color(0xFFD6F5F3),
              backgroundColor: const Color(0xFF102C57)
            ),
            child: const Text(
              'Delete',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17.5
              )
            ),
        ),
        TextButton(
            onPressed: () {
              String inName = nameController.text, inPrice = priceController.text;
              if(inPrice != '' && inName != '' && itemManager.addItem(inName, double.parse(inPrice))){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Item added successfully.',
                      style: TextStyle(fontSize: 20.0)
                    )
                  )
                );
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Error: Failed to add item.',
                      style: TextStyle(fontSize: 20.0)
                    )
                  )
                );
              }
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              fixedSize: const Size(75.0, 45.0),
              foregroundColor: const Color(0xFFD6F5F3),
              backgroundColor: const Color(0xFF102C57)
            ),
            child: const Text(
              'Add',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17.5
              ),
            )
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            fixedSize: const Size(75.0, 45.0),
            foregroundColor: const Color(0xFFD6F5F3),
            backgroundColor: const Color(0xFF102C57)
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17.5
            )
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsPadding: EdgeInsets.all(10.0),
    );
  }
}
