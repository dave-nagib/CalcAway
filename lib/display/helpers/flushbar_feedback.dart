import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showSuccessFlushbar(BuildContext context, String msg) {
  Flushbar(
    duration: const Duration(seconds: 3),
    flushbarStyle: FlushbarStyle.FLOATING,
    backgroundColor: const Color(0xFF619025),
    messageText: Text(
      msg,
      style: const TextStyle(
        fontFamily: 'Saira',
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ).show(context);
}

void showFailureFlushbar(BuildContext context, String msg) {
  Flushbar(
    duration: const Duration(seconds: 3),
    flushbarStyle: FlushbarStyle.FLOATING,
    backgroundColor: Colors.redAccent,
    messageText: Text(
      msg,
      style: const TextStyle(
        fontFamily: 'Saira',
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ).show(context);
}