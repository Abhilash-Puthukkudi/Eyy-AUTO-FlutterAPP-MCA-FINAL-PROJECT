import 'package:firebase_database/firebase_database.dart';

class History {
  String? paymentMethod;
  String? createdAt;
  String? status;
  String? fares;
  String? dropoff;
  String? pickup;

  History(
      {required this.createdAt,
      required this.paymentMethod,
      required this.status,
      required this.fares,
      required this.dropoff,
      required this.pickup});

  History.fromSnapshot(DatabaseEvent snapshot) {
    Map snapshotMap = snapshot.snapshot.value as Map;

    paymentMethod = snapshotMap["payment_method"];
    createdAt = snapshotMap["created_at"];
    status = snapshotMap["status"];
    fares = snapshotMap["fares"];
    dropoff = snapshotMap["dropoff_address"];
    pickup = snapshotMap["pickup_address"];
  }
}
