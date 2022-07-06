import 'dart:developer';

import 'package:driver/AllScreens/newRideScreen.dart';
import 'package:driver/assistance/assistanceMethods.dart';
import 'package:driver/functions/firebaseReferances.dart';
import 'package:driver/functions/validators.dart';
import 'package:driver/main.dart';
import 'package:driver/models/rideDetails.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NotificationDialouge extends StatelessWidget {
  // const NotificationDialouge({Key? key}) : super(key: key);
  final RideDetails? rideDetails;
  NotificationDialouge({this.rideDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      elevation: 1.0,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.yellow, borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30.0,
            ),
            Image.asset(
              "images/autorickshaw.png",
              width: 120.0,
            ),
            SizedBox(
              height: 18.0,
            ),
            Text("New Ride Request",
                style: TextStyle(fontFamily: "Brand Bold", fontSize: 30.0)),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "images/pickicon.png",
                        height: 20.0,
                        width: 20.0,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            rideDetails!.pickup_address.toString(),
                            style: TextStyle(
                                fontFamily: "Brand Bold", fontSize: 18.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "images/desticon.png",
                        height: 20.0,
                        width: 20.0,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            rideDetails!.dropoff_address.toString(),
                            style: TextStyle(
                                fontFamily: "Brand Bold", fontSize: 18.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Divider(),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        assetAudioPlayer.stop();
                        checkAvilabilityOfRide(context);
                        // Navigator.pop(context);
                      },
                      child: Text("Accept"),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  SizedBox(
                    width: 10.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        assetAudioPlayer.stop();
                        Navigator.pop(context);
                      },
                      child: Text("Decline"),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkAvilabilityOfRide(context) {
    // Map DriverReq;
    String theRideID = "";
    rideRequestRef.once().then((dataSnapshot) {
      Navigator.pop(context);
      log("RIDE REQUEST REF : " + dataSnapshot.snapshot.value.toString());
      if (dataSnapshot.snapshot.value != null) {
        // DriverReq = dataSnapshot.snapshot.value as Map;
        theRideID = dataSnapshot.snapshot.value.toString();
      } else {
        redMessenger(context, "RIDE NOT EXISTS!!");
      }
      log("ride id : " + theRideID);
      if (theRideID == rideDetails!.rideRequest_id) {
        rideRequestRef.set("accepted");
        assistanceMethods.disablehomeTabLiveLocationUpdates();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => newRideScreen(
                      rideDetails: rideDetails,
                    ))));
      } else if (theRideID == "cancelled") {
        redMessenger(context, "Ride Has been Cancelld");
      } else if (theRideID == "timeout") {
        redMessenger(context, "Ride has Timeout");
      } else {
        redMessenger(context, "RIDE NOT EXISTS!!");
      }
    });
  }
}
