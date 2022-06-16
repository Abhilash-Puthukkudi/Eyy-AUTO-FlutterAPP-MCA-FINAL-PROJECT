import 'dart:developer';

import 'package:eyyautoadmin/functions/validators.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/drivers_data.dart';
import '../models/passengers_data.dart';

class dashboardHome extends StatefulWidget {
  const dashboardHome({Key? key}) : super(key: key);
  static const String idScreen = "dashbordHome";

  @override
  State<dashboardHome> createState() => dashboardHomeState();
}

class dashboardHomeState extends State<dashboardHome> {
  List<DriversData> _acceptedDrivers = [];
  List<DriversData> _newDrivers = [];
  List<DriversData> _foundedDrivers = [];
  List<PassengersData> _allPassengers = [];
  List<PassengersData> _filteredPassengers = [];
  var passengerCount, driverCount, newdriverCount;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // countCalculator();
    getDrivers();
    getPassengers();
  }

  getPassengers() async {
    DatabaseEvent snapshotEvent = await passengerRef.once();
    final passengers_data =
        snapshotEvent.snapshot.value as Map<dynamic, dynamic>;
    List<PassengersData> data = [];
    passengers_data.forEach((key, value) {
      data.add(PassengersData.fromJson(value));
      // print(value);
    });

    setState(() {
      _allPassengers = data;
      passengerCount = _allPassengers.length;
    });
  }

  getDrivers() async {
    DatabaseEvent snapshotEvent = await driverRef.once();
    final drivers_data = snapshotEvent.snapshot.value as Map<dynamic, dynamic>;
    List<DriversData> data = [];
    drivers_data.forEach((key, value) {
      data.add(DriversData.fromJson(value));
      // print(value);
    });

    setState(() {
      _acceptedDrivers = data
          .where((driver) =>
              driver.status.toString().toLowerCase().contains('accepted'))
          .toList();

      _newDrivers = data
          .where((driver) =>
              driver.status.toString().toLowerCase().contains('waiting'))
          .toList();

      driverCount = _acceptedDrivers.length;
      newdriverCount = _newDrivers.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            height: 150,
            width: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.yellowAccent),
              borderRadius: BorderRadius.circular(10),
              color: Colors.yellow,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("Total Passengers",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: "Brand Bold")),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          passengerCount != null
                              ? passengerCount.toString()
                              : "Loading",
                          style: TextStyle(
                              fontSize: 50,
                              color: Colors.black,
                              fontFamily: "Brand Bold")),
                      Icon(
                        Icons.people,
                        size: 50,
                        color: Colors.black,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            height: 150,
            width: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.yellowAccent),
              borderRadius: BorderRadius.circular(10),
              color: Colors.yellow,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text("Total Drivers",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontFamily: "Brand Bold")),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          driverCount != null
                              ? driverCount.toString()
                              : "Loading",
                          style: TextStyle(
                              fontSize: 50,
                              color: Colors.black,
                              fontFamily: "Brand Bold")),
                      Icon(
                        Icons.co_present,
                        size: 50,
                        color: Colors.black,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            height: 150,
            width: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.yellowAccent),
              borderRadius: BorderRadius.circular(10),
              color: Colors.yellow,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text("New Driver Requests",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontFamily: "Brand Bold")),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          newdriverCount != null
                              ? newdriverCount.toString()
                              : "Loading",
                          style: TextStyle(
                              fontSize: 50,
                              color: Colors.black,
                              fontFamily: "Brand Bold")),
                      Icon(
                        Icons.new_label,
                        size: 50,
                        color: Colors.black,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
