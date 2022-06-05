import 'package:flutter/material.dart';

redMessenger(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color.fromARGB(255, 243, 6, 6), content: Text(msg)));
}

yellowMessenger(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Color.fromARGB(255, 234, 234, 15),
      content: Text(
        msg,
        style: TextStyle(color: Colors.black),
      )));
}

const colorizeColors = [
  Colors.black,
  Colors.blue,
  Colors.yellow,
  Colors.red,
  Colors.green,
];

const colorizeTextStyle = TextStyle(
  fontSize: 35.0,
  fontFamily: 'Brand Bold',
);
