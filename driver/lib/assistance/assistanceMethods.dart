import 'dart:developer';

import 'package:driver/functions/firebaseReferances.dart';
import 'package:driver/models/history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driver/DataHandler/appData.dart';
import 'package:driver/assistance/requestAssistance.dart';
import 'package:driver/functions/configMaps.dart';
import 'package:driver/models/address.dart';
import 'package:driver/models/directDetails.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/allUsers.dart';

class assistanceMethods {
  // static Future<String> searchCordinateAddress(
  //     Position position, context) async {
  //   String placeAddress = '';
  //   // String st1, st2, st3, st4;

  //   String url =
  //       "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey";
  //   log(url);
  //   var response = await requestAssistant.getRequest(url);
  //   log(position.latitude.toString());
  //   if (response != "failed") {
  //     String res = response["results"][0]["formatted_address"];

  //     List placeAddressList = res.split(",");

  //     placeAddress = placeAddressList[0] + " , " + placeAddressList[1];

  //     Address passengerPickupadress = new Address();
  //     passengerPickupadress.lattitude = position.latitude;
  //     passengerPickupadress.longitude = position.longitude;
  //     passengerPickupadress.placeName = placeAddress;

  //     Provider.of<appData>(context, listen: false)
  //         .updatePickupLocationAddress(passengerPickupadress);
  //   }

  //   return placeAddress;
  // }

  static Future<DirectionDetails> obtainPlaceDirectionDetails(
      LatLng initialposition, LatLng finalposition) async {
    String DirectionURL =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialposition.latitude},${initialposition.longitude}&destination=${finalposition.latitude},${finalposition.longitude}&key=$mapkey";

    log("direction URL : " + DirectionURL);
    var res = await requestAssistant.getRequest(DirectionURL);

    if (res == "failed") {}

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  static List calculateFares(DirectionDetails directionDetails) {
    double timeTraveldMinutes =
        (directionDetails.durationValue! / 60); // perminute

    /*
   minimum charge for an auto-rickshaw ride is Rs 30 for 1.5 km. 
   Each kilometre thereafter extra Rs 15 
   */

    double distanceTraveld = (directionDetails.distanceValue! / 1000);
    double fare = 0;
    if (distanceTraveld <= 1.5) {
      fare = 30.0;
    } else {
      double extradistance = distanceTraveld - 1.5;
      double extracharge = extradistance * 15;

      fare = extracharge + 30;
    }
    //km
    List returnList = [];
    returnList.add(fare.truncate());
    // creating HH MM string
    Duration dur = Duration(minutes: timeTraveldMinutes.truncate());
    String durationString =
        "${dur.inHours} Hours and ${dur.inMinutes.remainder(60)} Minutes";
    // log(durationString);
    returnList.add(durationString);

    return returnList;
  }

  // static void getCurrentOnlineUserInformation() async {
  //   firebaseUser = (await FirebaseAuth.instance.currentUser)!;
  //   String userId = firebaseUser!.uid;
  //   DatabaseReference reference =
  //       FirebaseDatabase.instance.ref().child("Passengers").child(userId);

  //   reference.once().then((value) => {
  //         if (value.snapshot.value != null)
  //           {userCurrentInfo = Users.fromSnapshot(value.snapshot)}
  //       });
  // }

// for making the driver unavilable till the ride completes
  static void disablehomeTabLiveLocationUpdates() {
    homeTabPageStreamSubscription!.pause();
    Geofire.removeLocation(currentFirebaseUSer!.uid);
  }

  static void enablehomeTabLiveLocationUpdates() {
    homeTabPageStreamSubscription!.resume();
    Geofire.setLocation(currentFirebaseUSer!.uid, currentPostiion!.latitude,
        currentPostiion!.longitude);
  }

  static void retriveHistoryInfo(context) {
    //  getting rattings
    driverRef
        .child(currentFirebaseUSer!.uid)
        .child("ratings")
        .once()
        .then((snapshot) {
      if (snapshot.snapshot.value != null) {
        String rattings = snapshot.snapshot.value.toString();
        startCounter = double.parse(rattings);

        if (startCounter <= 2) {
          title = "very bad";
        } else if (startCounter <= 3) {
          title = "bad";
        } else if (startCounter <= 4) {
          title = "good";
        } else if (startCounter < 5) {
          title = "Very Good";
        } else if (startCounter > 5) {
          title = "Excellent";
        }
      }
    });

    driverRef
        .child(currentFirebaseUSer!.uid)
        .child("earnings")
        .once()
        .then((snapshot) {
      if (snapshot.snapshot.value != null) {
        String earnings = snapshot.snapshot.value.toString();
        Provider.of<appData>(context, listen: false).updateEarnings(earnings);
      }
    });
// retirve history
    driverRef
        .child(currentFirebaseUSer!.uid)
        .child("history")
        .once()
        .then((snapshot) {
      if (snapshot.snapshot.value != null) {
        Map keys = snapshot.snapshot.value as Map;
        int tripCounter = keys.length;
        Provider.of<appData>(context, listen: false)
            .updateTripsCounter(tripCounter);

        List<String> triphistoryKeys = [];
        keys.forEach((key, value) {
          triphistoryKeys.add(key);
        });
        Provider.of<appData>(context, listen: false)
            .updateTripsKeys(triphistoryKeys);
        obtainTripHistoryData(context);
      }
    });
  }

  static void obtainTripHistoryData(context) {
    var keys = Provider.of<appData>(context, listen: false).tripHistoryKeys;

    for (String key in keys) {
      newRideRequestRef.child(key).once().then((snapshot) {
        if (snapshot.snapshot.value != null) {
          var history = History.fromSnapshot(snapshot);
          Provider.of<appData>(context, listen: false)
              .updateTripHistoryData(history);
        }
      });
    }
  }

  static String formatTripdate(String date) {
    DateTime dateTime = DateTime.parse(date);

    String formatedDate =
        "${DateFormat.MMMd().format(dateTime)},${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";
    return formatedDate;
  }
}


// st1 = response["results"][0]["address_components"][2]["long_name"]; //3
// st2 = response["results"][0]["address_components"][4]["long_name"]; //4
// st3 = response["results"][0]["address_components"][5]["long_name"];
// st4 = response["results"][0]["address_components"][6]["long_name"];

// placeAddress = st1 + "," + st2 + "," + st3;
