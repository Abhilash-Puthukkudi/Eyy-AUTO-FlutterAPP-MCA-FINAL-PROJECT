import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideDetails {
  String? pickup_address;
  String? dropoff_address;
  LatLng? pickUp;
  LatLng? dropOff;
  String? rideRequest_id;
  String? riderName;
  String? riderPhone;
  RideDetails(
      {this.pickup_address,
      this.dropoff_address,
      this.pickUp,
      this.dropOff,
      this.rideRequest_id,
      this.riderName,
      this.riderPhone});
}
