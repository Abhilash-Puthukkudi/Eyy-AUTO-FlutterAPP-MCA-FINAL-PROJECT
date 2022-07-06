import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver/functions/configMaps.dart';
import 'package:driver/functions/firebaseReferances.dart';
import 'package:driver/models/rideDetails.dart';
import 'package:driver/notifications/notificationDialouge.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as noti;
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotficationService {
  noti.FirebaseMessaging firebaseMessaging = noti.FirebaseMessaging.instance;
  late BuildContext homescreen_context;

  Future initialize(BuildContext context) async {
    log("INITZALIED BLA BLA");
    homescreen_context = context;
    log("context Status :" + homescreen_context.toString());
    noti.NotificationSettings settings =
        await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

//     firebaseMessaging.onMessage.listen((RemoteMessage message) {
//   print('Got a message whilst in the foreground!');
//   print('Message data: ${message.data}');

//   if (message.notification != null) {
//     print('Message also contained a notification: ${message.notification}');
//   }
// });

  Future getToken() async {
    String? token = await firebaseMessaging.getToken();
    print("This is token");
    print("token: ${token}");
    driverRef.child(currentFirebaseUSer!.uid).child("token").set(token);
    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");
  }

  String getRideRequestId(String message) {
    String rideRequestId = "";
    if (Platform.isAndroid) {
      rideRequestId = message;
    }
    // log("ride requestID : " + rideRequestId);
    return rideRequestId;
  }

  void retriveRideRequestInfo(String rideRequestId) {
    log("RIDE REQUEST ID : " + rideRequestId);
    Map rideRequestMap;
    newRideRequestRef.child(rideRequestId).once().then((datasnapshot) {
      // log(datasnapshot.snapshot.value.toString());
      if (datasnapshot.snapshot.value != null) {
        // adding notification sound
        assetAudioPlayer.open(Audio("sounds/alert.mp3"));
        assetAudioPlayer.play();
        // end of sound
        rideRequestMap = datasnapshot.snapshot.value as Map;

        double pickUpLocationLat =
            double.parse(rideRequestMap['pickup']['latitude'].toString());

        double pickUpLocationLng =
            double.parse(rideRequestMap['pickup']['longitude'].toString());

        String pickUpAddress = rideRequestMap['pickup_address'].toString();

        double dropOffLocationLat =
            double.parse(rideRequestMap['dropoff']['latitude'].toString());

        double dropOffLocationLng =
            double.parse(rideRequestMap['dropoff']['longitude'].toString());

        String dropOffAddress = rideRequestMap['dropoff_address'].toString();
        String riderName = rideRequestMap['rider_name'].toString();
        String riderPhone = rideRequestMap['rider_phone'].toString();

        RideDetails rideDetails = RideDetails();

        rideDetails.pickup_address = pickUpAddress;
        rideDetails.dropoff_address = dropOffAddress;
        rideDetails.pickUp = LatLng(pickUpLocationLat, pickUpLocationLng);
        rideDetails.dropOff = LatLng(dropOffLocationLat, dropOffLocationLng);
        rideDetails.rideRequest_id = rideRequestId.toString();
        rideDetails.riderName = riderName;
        rideDetails.riderPhone = riderPhone;
        log("reached here");
        log("Informations  : " + (rideDetails.pickup_address as String));
        log("Golobal home context : " + homeScreenContext.toString());
        // showing ride request screen
        showDialog(
            context: homeScreenContext as BuildContext,
            barrierDismissible: false,
            builder: (BuildContext context) => NotificationDialouge(
                  rideDetails: rideDetails,
                ));
        // ending showing ride request screen
      } else {
        log("error occurred");
      }
    });
  }
}
