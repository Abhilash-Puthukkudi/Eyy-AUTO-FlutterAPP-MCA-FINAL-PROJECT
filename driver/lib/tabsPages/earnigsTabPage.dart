import 'dart:ui';

import 'package:driver/AllScreens/HistoryScreen.dart';
import 'package:driver/DataHandler/appData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class earningsTab extends StatefulWidget {
  const earningsTab({Key? key}) : super(key: key);

  @override
  State<earningsTab> createState() => _earningsTabState();
}

class _earningsTabState extends State<earningsTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.black87,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 250),
            child: Column(
              children: [
                Text(
                  "Total earnings",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  Provider.of<appData>(context, listen: false).earnings,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 80,
                      fontFamily: "Brand Bold"),
                )
              ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HistoryScreen()));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 34),
            child: Row(
              children: [
                Image.asset(
                  "images/autorickshaw.png",
                  width: 70,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  "Total Trips",
                  style: TextStyle(fontSize: 16),
                ),
                Expanded(
                    child: Container(
                  child: Text(
                    Provider.of<appData>(context, listen: false)
                        .countTrips
                        .toString(),
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 18),
                  ),
                ))
              ],
            ),
          ),
        )
      ],
    );
  }
}
