import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:passenger/DataHandler/appData.dart';
import 'package:passenger/assistance/requestAssistance.dart';
import 'package:passenger/functions/configMaps.dart';
import 'package:passenger/models/address.dart';
import 'package:passenger/models/directDetails.dart';
import 'package:provider/provider.dart';

import '../models/allUsers.dart';

// assistant method class conatain all the REST API & Google API Handling functions
// and Distance,fare,time calculating functions map handling functions
class assistanceMethods {
  static Future<String> searchCordinateAddress(
      Position position, context) async {
    String placeAddress = '';
    // String st1, st2, st3, st4;

    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey";
    // log(url);
    var response = await requestAssistant.getRequest(url);
    // log(position.latitude.toString());
    if (response != "failed") {
      String res = response["results"][0]["formatted_address"];

      List placeAddressList = res.split(",");

      placeAddress = placeAddressList[0] + " , " + placeAddressList[1];

      Address passengerPickupadress = new Address();
      passengerPickupadress.lattitude = position.latitude;
      passengerPickupadress.longitude = position.longitude;
      passengerPickupadress.placeName = placeAddress;

      Provider.of<appData>(context, listen: false)
          .updatePickupLocationAddress(passengerPickupadress);
    }

    return placeAddress;
  }

  static Future<DirectionDetails> obtainPlaceDirectionDetails(
      LatLng initialposition, LatLng finalposition) async {
    String DirectionURL =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialposition.latitude},${initialposition.longitude}&destination=${finalposition.latitude},${finalposition.longitude}&key=$mapkey";

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

  static void getCurrentOnlineUserInformation() async {
    firebaseUser = (await FirebaseAuth.instance.currentUser)!;
    String userId = firebaseUser!.uid;
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child("Passengers").child(userId);

    reference.once().then((value) => {
          if (value.snapshot.value != null)
            {userCurrentInfo = Users.fromSnapshot(value.snapshot)}
        });
  }

  static double createRandomNumber(int number) {
    var random = Random();
    int ranNumber = random.nextInt(number);
    return ranNumber.toDouble();
  }

  static sendNotification(String token, context, String ride_request_id) async {
    var destination =
        Provider.of<appData>(context, listen: false).dropOffLocation;
    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': SERVER_KEY,
    };

    Map notificationMap = {
      'body': 'Dropoff Address,${destination!.placeName}',
      'title': 'New Ride Request',
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "ride__request_id": ride_request_id
    };

    Map sendNotificationMap = {
      "notification": notificationMap,
      "data": dataMap,
      "priority": "high",
      "to": token
    };
    try {
      var res = await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: headerMap,
        body: jsonEncode(sendNotificationMap),
      );
    } catch (e) {
      dev.log("exception " + e.toString());
    }
  }
}

// st1 = response["results"][0]["address_components"][2]["long_name"]; //3
// st2 = response["results"][0]["address_components"][4]["long_name"]; //4
// st3 = response["results"][0]["address_components"][5]["long_name"];
// st4 = response["results"][0]["address_components"][6]["long_name"];

// placeAddress = st1 + "," + st2 + "," + st3;
