import 'package:flutter/material.dart';

class manageDriver extends StatefulWidget {
  const manageDriver({Key? key}) : super(key: key);
  static const String idScreen = "manageDrivers";
  @override
  State<manageDriver> createState() => _manageDriverState();
}

class _manageDriverState extends State<manageDriver> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("this is manage drivers"));
  }
}
