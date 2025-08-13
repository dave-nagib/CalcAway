import 'package:calc_away/data/models/item.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class AddItemDialog extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  AddItemDialog({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      backgroundColor: const Color(0xF01F3133),
      title: const Center(child: Text('New Item')),
      titleTextStyle: const TextStyle(
        fontFamily: 'Saira',
        fontSize: 35.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      content: SizedBox(
        width: screenWidth * 0.8,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _NewItemTextField(
                  title: 'Name',
                  controller: _nameController,
                  validator: (name) {
                    if (name.isEmpty) {
                      return 'Name cannot be empty.';
                    }
                    if (name.length < 5 || name.length > 50) {
                      return 'Name must be between 5 and 50 characters long.';
                    }
                    if (!RegExp(r'^([\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFFa-zA-Z0-9-] ?)+$').hasMatch(name)) {
                      return 'Name must only contain English or Arabic characters, numbers, or a hyphen -. Each word can only be separated by a single space.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                _NewItemTextField(
                  title: 'Price',
                  controller: _priceController,
                  validator: (price) {
                    if (price.isEmpty) {
                      return 'Price cannot be empty.';
                    }
                    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(price)) {
                      return 'Price must be a positive number with up to two decimal places.';
                    }
                    if (double.tryParse(price)! <= 0.0) {
                      return 'Price must be greater than 0.';
                    }
                    return null;
                  },
                  numberOnly: true,
                ),
                const SizedBox(height: 10.0),
                _NewItemTextField(
                  title: 'Discount %',
                  controller: _discountController,
                  validator: (discount) {
                    if (discount.isEmpty) {
                      return 'Discount cannot be empty.';
                    }
                    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(discount)) {
                      return 'Discount must be a positive number with up to two decimal places.';
                    }
                    if (double.tryParse(discount)! <= 0.0) {
                      return 'Discount must be greater than 0.';
                    }
                    return null;
                  },
                  numberOnly: true,
                ),
              ],
            ),
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsPadding: const EdgeInsets.symmetric(vertical: 10.0),
      actions: [
        TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Colors.tealAccent, width: 3.0)
                  )
              ),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0)
              )
          ),
          child: const Text(
              'Cancel',
              style: TextStyle(
                  color: Colors.tealAccent,
                  fontFamily: 'Saira',
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  letterSpacing: 0.8
              )
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Color(0xFF1F3133), width: 3.0)
                  )
              ),
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.tealAccent.withOpacity(0.6);
                }
                return Colors.tealAccent;
              }),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0)
              )
          ),
          child: const Text(
              'Add',
              style: TextStyle(
                  color: Color(0xFF1F3133),
                  fontFamily: 'Saira',
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  letterSpacing: 0.8
              )
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // TODO actually add the item using the item service and display flushbar accordingly
              // Valid data
              Flushbar(
                duration: const Duration(seconds: 3),
                flushbarStyle: FlushbarStyle.FLOATING,
                backgroundColor: const Color(0xFF619025),
                messageText: const Text(
                  'Item added successfully.',
                  style: TextStyle(
                    fontFamily: 'Saira',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ).show(context);
            } else {
              // Invalid data
              Flushbar(
                duration: const Duration(seconds: 3),
                flushbarStyle: FlushbarStyle.FLOATING,
                backgroundColor: Colors.redAccent,
                messageText: const Text(
                  'New item data is invalid. Please fix the errors first.',
                  style: TextStyle(
                    fontFamily: 'Saira',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ).show(context);
            }
          },
        ),
      ],
    );
  }
}

class _NewItemTextField extends StatelessWidget {
  final TextEditingController _controller;
  final String? Function (String?) _validator;
  final String _title;
  final bool _numberOnly;

  const _NewItemTextField({required controller, required validator, required title, numberOnly})
      : _controller = controller,
        _validator = validator,
        _title = title,
        _numberOnly = numberOnly ?? false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _controller,
      validator: _validator,
      keyboardType: _numberOnly ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: _title,
        labelStyle: const TextStyle(
          fontFamily: 'Saira',
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.tealAccent,
        ),
        fillColor: const Color(0xF0284043),
        errorStyle: const TextStyle(
          fontFamily: 'Saira',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.redAccent,
          overflow: TextOverflow.visible,
        ),
        errorMaxLines: 4,
      ),
      style: const TextStyle(
        fontFamily: 'Saira',
        fontSize: 20.0,
        color: Colors.white,
      ),
    );
  }
}
