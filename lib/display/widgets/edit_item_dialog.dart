import 'package:calc_away/data/models/item.dart';
import 'package:calc_away/display/helpers/flushbar_feedback.dart';
import 'package:calc_away/services/items_page_service.dart';
import 'package:flutter/material.dart';

class EditItemDialog extends StatelessWidget {

  final Item item;
  final double discount;
  final ItemsPageService itemService;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  EditItemDialog({required this.item, required this.discount, required this.itemService, super.key}) {
    _nameController.text = item.name;
    _priceController.text = item.price.toString();
    _discountController.text = discount.toString();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      backgroundColor: const Color(0xF01F3133),
      title: const Center(child: Text('Edit Item')),
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
                _UpdateTextField(
                  title: 'Name',
                  currValue: item.name,
                  controller: _nameController,
                  validator: itemService.nameValidator,
                ),
                const SizedBox(height: 10.0),
                _UpdateTextField(
                  title: 'Price',
                  currValue: item.price.toStringAsFixed(2),
                  controller: _priceController,
                  validator: itemService.priceValidator,
                  numberOnly: true,
                ),
                const SizedBox(height: 10.0),
                _UpdateTextField(
                  title: 'Discount %',
                  currValue: discount.toStringAsFixed(2),
                  controller: _discountController,
                  validator: itemService.discountValidator,
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
              'Confirm',
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
              // Pop dialog if no changes were made
              if (_nameController.text.trim() == item.name &&
                  _priceController.text.trim() == item.price.toString() &&
                  _discountController.text.trim() == discount.toString()) {
                Navigator.of(context).pop(false);
              }
              // Valid data
              itemService.updateItem(
                item.id!,
                _nameController.text.trim(),
                _priceController.text.trim(),
                _discountController.text.trim(),
              ).then((success) {
                if (success) {
                  // Pop dialog and show feedback from items page
                  Navigator.of(context).pop(true);
                } else {
                  showFailureFlushbar(context, 'Could not update item due to an error. Please try again.');
                }
              });
            } else {
              // Invalid data
              showFailureFlushbar(context, 'New item data is invalid. Please fix the errors first.');
            }
          },
        ),
      ],
    );
  }
}

class _UpdateTextField extends StatelessWidget {
  final TextEditingController _controller;
  final String? Function (String?) _validator;
  final String _title;
  final String _currValue;
  final bool _numberOnly;

  const _UpdateTextField({required controller, required validator, required title, required currValue, numberOnly})
      : _controller = controller,
        _validator = validator,
        _title = title,
        _currValue = currValue,
        _numberOnly = numberOnly ?? false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 12,
          child: TextField(
            controller: TextEditingController(text: _currValue),
            readOnly: true,
            decoration: InputDecoration(
              fillColor: const Color(0xF0284043),
              labelText: _title,
              labelStyle: const TextStyle(
                fontFamily: 'Saira',
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.tealAccent,
              ),
            ),
            style: const TextStyle(
              fontFamily: 'Saira',
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
        const Spacer(flex: 1),
        const Expanded(flex: 4, child: Icon(Icons.arrow_circle_right_rounded, size: 35.0, color: Colors.tealAccent)),
        const Spacer(flex: 1),
        Expanded(
          flex: 12,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _controller,
            validator: _validator,
            keyboardType: _numberOnly ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              fillColor: const Color(0xF0284043),
              hintText: 'New ${_title.toLowerCase()}',
              hintStyle: const TextStyle(
                fontFamily: 'Saira',
                fontSize: 17.5,
                color: Colors.white24,
              ),
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
          ),
        ),
      ],
    );
  }
}
