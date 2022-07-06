import 'package:driver/assistance/assistanceMethods.dart';
import 'package:flutter/material.dart';

class CollectFareDialog extends StatelessWidget {
  final String paymentMethod;
  final int fareAmount;

  CollectFareDialog({required this.paymentMethod, required this.fareAmount});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 22.0),
            Text(
              "Cash Payment",
              style: TextStyle(
                  fontFamily: "Brand Bold",
                  fontSize: 18.0,
                  color: Colors.green),
            ),
            SizedBox(height: 22.0),
            Divider(),
            SizedBox(
              height: 16.0,
            ),
            Text(
              fareAmount.toString(),
              style: TextStyle(fontSize: 55.0, fontFamily: "Brand Bold"),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "This is the Total Trip amount",
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30.0),
            // button goes here
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    assistanceMethods.enablehomeTabLiveLocationUpdates();
                  },
                  child: Text("Collect Cash"),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.yellow,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      textStyle: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
            ),
            SizedBox(
              height: 30.0,
            )
          ],
        ),
      ),
    );
  }
}
