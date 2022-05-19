import 'package:flutter/material.dart';
import 'package:passenger/models/address.dart';

class appData extends ChangeNotifier {
  Address? pickUpLocation;

  void updatePickupLocationAddress(Address pickupaddress) {
    pickUpLocation = pickupaddress;
    notifyListeners();
  }
}
