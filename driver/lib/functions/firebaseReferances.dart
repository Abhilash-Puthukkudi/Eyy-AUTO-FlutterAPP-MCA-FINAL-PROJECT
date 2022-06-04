//user referances

import 'package:firebase_database/firebase_database.dart';

DatabaseReference passengerRef =
    FirebaseDatabase.instance.ref().child("Passengers");
DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("drivers");
