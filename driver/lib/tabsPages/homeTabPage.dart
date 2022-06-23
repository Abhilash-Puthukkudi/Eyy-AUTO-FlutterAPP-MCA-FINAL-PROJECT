import 'package:flutter/material.dart';

class homeTab extends StatefulWidget {
  const homeTab({Key? key}) : super(key: key);

  @override
  State<homeTab> createState() => _homeTabState();
}

class _homeTabState extends State<homeTab> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("this is home tab"));
  }
}
