import 'dart:developer';

import 'package:eyyautoadmin/functions/validators.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class dashboardHome extends StatefulWidget {
  const dashboardHome({Key? key}) : super(key: key);
  static const String idScreen = "dashbordHome";

  @override
  State<dashboardHome> createState() => dashboardHomeState();
}

class dashboardHomeState extends State<dashboardHome> {
  var passengerCount, driverCount;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countCalculator();
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
                      SizedBox(width: 10,),
                      Text("Total Drivers",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontFamily: "Brand Bold")),
                              SizedBox(width: 10,)
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
        )
      ],
    );
  }

  void countCalculator() async {
    DataSnapshot passengerEvent = await passengerRef.get();
    
    Map? passengers = passengerEvent.value as Map?;
    setState(() {
      passengerCount = passengers!.length;
    });

    DataSnapshot DriverEvent = await driverRef.get();
    Map? drivers = DriverEvent.value as Map?;
    setState(() {
      driverCount = drivers!.length;
    });

    log(passengerCount.toString());
    log(driverCount.toString());

    // log(passengerEvent.value.toString());

    // log(passengers.toString());
  }
}
