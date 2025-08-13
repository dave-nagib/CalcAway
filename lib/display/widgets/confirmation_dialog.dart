import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;

  const ConfirmationDialog({
    this.title = 'Confirmation',
    this.content = 'Are you sure?\nThis action cannot be undone.',
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      backgroundColor: const Color(0xD7460909),
      title: Center(child: Text(title)),
      titleTextStyle: const TextStyle(
        fontFamily: 'Saira',
        fontSize: 35.0,
        fontWeight: FontWeight.bold,
        color: Colors.orangeAccent,
      ),
      content: Text(
        content,
        style: const TextStyle(fontFamily: 'Saira', fontSize: 25.0, color: Color(0xFFFFFFFF)),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsPadding: const EdgeInsets.symmetric(vertical: 10.0),
      actions: [
        TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: const BorderSide(color: Colors.orangeAccent, width: 3.0)
              )
            ),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0)
            )
          ),
          child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.orangeAccent,
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
                side: const BorderSide(color: Color(0xFF460909), width: 3.0)
              )
            ),
            backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0)
            )
          ),
          child: const Text(
              'Confirm',
              style: TextStyle(
                color: Color(0xFF460909),
                fontFamily: 'Saira',
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
                letterSpacing: 0.8
              )
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
