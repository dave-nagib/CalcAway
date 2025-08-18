import 'package:flutter/material.dart';

class AddDiscountDialog extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _discountController = TextEditingController();
  final String? Function(String?)? validator;

  AddDiscountDialog({required this.validator, super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      backgroundColor: const Color(0xF01F3133),
      title: const Center(child: Text('Set discount')),
      titleTextStyle: const TextStyle(
        fontFamily: 'Saira',
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      content: SizedBox(
        width: screenWidth * 0.8,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: TextFormField(
              autofocus: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _discountController,
              validator: validator,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Discount %',
                labelStyle: TextStyle(
                  fontFamily: 'Saira',
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.tealAccent,
                ),
                fillColor: Color(0xF0284043),
                errorStyle: TextStyle(
                  fontFamily: 'Saira',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                  overflow: TextOverflow.visible,
                ),
                errorMaxLines: 4,
              ),
              style: const TextStyle(
                fontFamily: 'Saira',
                fontSize: 24.0,
                color: Colors.white,
              ),
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
          onPressed: () => Navigator.of(context).pop(),
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
              Navigator.of(context).pop(double.parse(_discountController.text));
            }
          },
        ),
      ],
    );
  }
}