import 'dart:convert';
import 'dart:js';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:passenger/DataHandler/appData.dart';
import 'package:passenger/assistance/requestAssistance.dart';
import 'package:passenger/functions/configMaps.dart';
import 'package:passenger/models/address.dart';
import 'package:provider/provider.dart';

class assistanceMethods {
  static Future<String> searchCordinateAddress(
      Position position, context) async {
    String placeAddress = '';

    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey";

    var response = await requestAssistant.getRequest(url);

    if (response != "failed") {
      // placeAddress = response["results"][0]["formatted_address"];
      placeAddress =
          response["results"][0]["address_components"][0]["long_name"];

      Address passengerPickupadress = new Address();
      passengerPickupadress.longitude = position.latitude;
      passengerPickupadress.longitude = position.longitude;
      passengerPickupadress.placeName = placeAddress;

      Provider.of<appData>(context, listen: false)
          .updatePickupLocationAddress(passengerPickupadress);
    }

    return placeAddress;
  }
}
