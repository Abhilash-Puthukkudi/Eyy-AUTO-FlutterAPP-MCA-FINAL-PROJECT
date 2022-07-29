import 'package:driver/assistance/assistanceMethods.dart';
import 'package:driver/models/history.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({required this.history});
  final History history;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              children: [
                Image.asset(
                  "images/pickicon.png",
                  height: 16,
                  width: 16,
                ),
                SizedBox(
                  width: 18,
                ),
                Expanded(
                    child: Container(
                  child: Text(
                    history.pickup.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: "Brand Bold", fontSize: 16),
                  ),
                )),
                SizedBox(
                  width: 5,
                ),
                Text(
                  history.dropoff.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                "images/desticon.png",
                width: 16,
                height: 16,
              ),
              SizedBox(
                width: 18,
              ),
              Text(
                history.dropoff.toString(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            assistanceMethods
                .formatTripdate(history.createdAt.toString())
                .toString(),
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
