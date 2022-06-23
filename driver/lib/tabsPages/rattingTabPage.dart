import 'package:flutter/material.dart';

class ratingTab extends StatefulWidget {
  const ratingTab({Key? key}) : super(key: key);

  @override
  State<ratingTab> createState() => _ratingTabState();
}

class _ratingTabState extends State<ratingTab> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("this is Rating tab page"));
  }
}
