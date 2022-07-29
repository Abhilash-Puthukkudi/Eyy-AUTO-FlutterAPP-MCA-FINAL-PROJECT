import 'package:flutter/material.dart';
import 'package:passenger/models/address.dart';

class appData extends ChangeNotifier {
  Address? pickUpLocation, dropOffLocation;

  void updatePickupLocationAddress(Address pickupaddress) {
    pickUpLocation = pickupaddress;
    notifyListeners();
  }
      
  void updateDropOffLocationAddress(Address dropoffaddress) {
    dropOffLocation = dropoffaddress;
    notifyListeners();
  }
}
