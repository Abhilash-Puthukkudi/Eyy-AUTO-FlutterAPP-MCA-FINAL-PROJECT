import 'package:driver/DataHandler/appData.dart';
import 'package:driver/allwidgets/listviewitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Trip Hisroy",
              style: TextStyle(fontFamily: "Brand Bold", color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_arrow_left, color: Colors.yellow),
          )),
      body: ListView.separated(
        itemBuilder: ((context, index) {
          return HistoryItem(
              history: Provider.of<appData>(context, listen: false)
                  .tripHistoryDatalist[index]);
        }),
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: Provider.of<appData>(context, listen: false)
            .tripHistoryDatalist
            .length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}
