import 'package:flutter/material.dart';

class earningsTab extends StatefulWidget {
  const earningsTab({Key? key}) : super(key: key);

  @override
  State<earningsTab> createState() => _earningsTabState();
}

class _earningsTabState extends State<earningsTab> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("this is earnings tab"));
  }
}
