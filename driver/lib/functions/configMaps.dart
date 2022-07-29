import 'dart:async';

import 'package:driver/models/drivers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

import '../models/allUsers.dart';

String mapkey = "AIzaSyAuVHHq2XMD-iXvIeujl0RdtrJdO8_qdKE";

User? firebaseUser;

Users? userCurrentInfo;

User? currentFirebaseUSer;

StreamSubscription<Position>? homeTabPageStreamSubscription;
StreamSubscription<Position>? rideStreamSubscription;
Position? currentPostiion;
drivers? driversInformation;
String? title;
double startCounter = 0.0;
