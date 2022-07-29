import 'package:driver/models/history.dart';
import 'package:flutter/material.dart';
import 'package:driver/models/address.dart';

class appData extends ChangeNotifier {
  Address? pickUpLocation, dropOffLocation;

  String earnings = "0";
  int countTrips = 0;
  List<String> tripHistoryKeys = [];

  List<History> tripHistoryDatalist = [];

  void updateEarnings(String updatedEarnings) {
    earnings = updatedEarnings;
    notifyListeners();
  }

  void updateTripsCounter(int tripCounter) {
    countTrips = tripCounter;
    notifyListeners();
  }

  void updateTripsKeys(List<String> newKeys) {
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateTripHistoryData(History eachHistory) {
    tripHistoryDatalist.add(eachHistory);
    notifyListeners(); 
  }
}
