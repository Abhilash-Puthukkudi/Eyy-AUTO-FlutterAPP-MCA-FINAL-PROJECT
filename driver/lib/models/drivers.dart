import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

class drivers {
  String? name;
  String? phone;
  String? email;
  String? id;
  String? auto_number;
  String? licence_number;

  drivers(
      {this.name,
      this.phone,
      this.email,
      this.id,
      this.auto_number,
      this.licence_number});

  drivers.fromSnapshot(DataSnapshot dataSnapshot) {
    Map driverdataSnapshotValues;
    log("[drivers class] fromSnapshot : " + dataSnapshot.value.toString());
    if (dataSnapshot.value != null) {
      log("[drivers class] fromSnapshot : null check passed");
      driverdataSnapshotValues = dataSnapshot.value as Map;
      id = dataSnapshot.key;
      phone = driverdataSnapshotValues["phone"];
      email = driverdataSnapshotValues["email"];
      name = driverdataSnapshotValues["name"];
      auto_number = driverdataSnapshotValues["auto_Details"]["auto_number"];
      licence_number =
          driverdataSnapshotValues["auto_Details"]["licence_number"];
    }
  }
}
