import 'dart:developer';

import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passenger/DataHandler/appData.dart';
import 'package:passenger/assistance/requestAssistance.dart';
import 'package:passenger/functions/configMaps.dart';
import 'package:passenger/models/address.dart';
import 'package:provider/provider.dart';

class assistanceMethods {
  static Future<String> searchCordinateAddress(
      Position position, context) async {
    String placeAddress = '';
    // String st1, st2, st3, st4;

    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey";
    log(url);
    var response = await requestAssistant.getRequest(url);

    if (response != "failed") {
      String res = response["results"][0]["formatted_address"];

      List placeAddressList = res.split(",");

      placeAddress = placeAddressList[0] + " , " + placeAddressList[1];

      // st1 = response["results"][0]["address_components"][2]["long_name"]; //3
      // st2 = response["results"][0]["address_components"][4]["long_name"]; //4
      // st3 = response["results"][0]["address_components"][5]["long_name"];
      // st4 = response["results"][0]["address_components"][6]["long_name"];

      // placeAddress = st1 + "," + st2 + "," + st3;

      Address passengerPickupadress = new Address();
      passengerPickupadress.longitude = position.latitude;
      passengerPickupadress.longitude = position.longitude;
      passengerPickupadress.placeName = placeAddress;

      Provider.of<appData>(context, listen: false)
          .updatePickupLocationAddress(passengerPickupadress);
    }

    return placeAddress;
  }

  void obtainPlaceDirectionDetails(
      LatLng initialposition, LatLng finalposition) async {
    String DirectionURL =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialposition.latitude},${initialposition.longitude}&destination=${finalposition.latitude},${finalposition.longitude}&key=$mapkey";

    var res = await requestAssistant.getRequest(DirectionURL);

    if (res == "failed") {
      return;
    }
  }
}
