import 'package:flutter/material.dart';

redMessenger(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color.fromARGB(255, 243, 6, 6), content: Text(msg)));
}

greenMessenger(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color.fromARGB(255, 63, 236, 10), content: Text(msg)));
}
