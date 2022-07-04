//user referances

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

DatabaseReference passengerRef =
    FirebaseDatabase.instance.ref().child("Passengers");
DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("drivers");
DatabaseReference newRideRequestRef =
    FirebaseDatabase.instance.ref().child("Ride Requests");

BuildContext? homeScreenContext;
