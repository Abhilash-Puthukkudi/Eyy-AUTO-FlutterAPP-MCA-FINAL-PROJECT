import 'package:flutter/material.dart';

class DividorWidget extends StatefulWidget {
  const DividorWidget({Key? key}) : super(key: key);

  @override
  State<DividorWidget> createState() => _DividorWidgetState();
}

class _DividorWidgetState extends State<DividorWidget> {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1.0,
      color: Colors.black,
      thickness: 1.0,
    );
  }
}
