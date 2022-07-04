import 'package:driver/models/rideDetails.dart';
import 'package:flutter/material.dart';

class newRideScreen extends StatefulWidget {
  // const newRideScreen({Key? key}) : super(key: key);
  final RideDetails? rideDetails;
  newRideScreen({this.rideDetails});

  @override
  State<newRideScreen> createState() => _newRideScreenState();
}

class _newRideScreenState extends State<newRideScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Ride"),
      ),
      body: Center(
        child: Text("This is new ride page"),
      ),
    );
  }
}
