import 'dart:developer';

import 'package:eyyautoadmin/functions/validators.dart';
import 'package:eyyautoadmin/models/passengers_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class viewPassengers extends StatefulWidget {
  const viewPassengers({Key? key}) : super(key: key);
  static const String idScreen = "viewPassengers";
  @override
  State<viewPassengers> createState() => _viewPassengersState();
}

class _viewPassengersState extends State<viewPassengers> {
  TextEditingController searchTextController = TextEditingController();
  late Map<dynamic, dynamic> passengerMap;
  List<PassengersData> _allPassengers = [];
  List<PassengersData> _filteredPassengers = [];

  @override
  void initState() {
    getPassengers();
    super.initState();
  }

  getPassengers() async {
    DatabaseEvent snapshotEvent = await passengerRef.once();
    final passengers_data =
        snapshotEvent.snapshot.value as Map<dynamic, dynamic>;
    List<PassengersData> data = [];
    passengers_data.forEach((key, value) {
      data.add(PassengersData.fromJson(value));
      print(value);
    });
    print(_allPassengers);

    setState(() {
      _allPassengers = data;
      _filteredPassengers = _allPassengers;
    });
  }

  void _filterPass(String enteredKeyword) {
    List<PassengersData> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allPassengers;
    } else {
      results = _allPassengers
          .where((emp) => emp.name!
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _filteredPassengers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              const SizedBox(
                width: 450,
              ),
              Container(
                width: 400,
                // child: TextField(
                //   controller: searchTextController,
                //   textAlign: TextAlign.center,
                //   style: const TextStyle(color: Colors.yellow, fontSize: 18),
                //   decoration: const InputDecoration(
                //       border: OutlineInputBorder(),
                //       labelText: "Search...",
                //       labelStyle:
                //           TextStyle(fontSize: 14.0, color: Colors.white),
                //       hintStyle: TextStyle(fontSize: 10.0, color: Colors.grey)),
                // ),
                child: Column(children: [
                  const Text("View Passenger",
                      style: TextStyle(
                          color: Colors.yellow,
                          fontFamily: "Brand Bold",
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  Container(
                    width: 400,
                    child: ListTile(
                      trailing: GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.search,
                          size: 30,
                          color: Colors.yellow,
                        ),
                      ),
                      title: TextField(
                        onChanged: (value) {
                          _filterPass(value);
                        },
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.yellow, fontSize: 18),
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Search...",
                            labelStyle:
                                TextStyle(fontSize: 14.0, color: Colors.white),
                            hintStyle:
                                TextStyle(fontSize: 10.0, color: Colors.grey)),
                      ),
                    ),
                  )
                ]),
              ),
            ],
          ),
          ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final passenger = _filteredPassengers[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(200, 8, 200, 8),
                  child: Container(
                      height: 250,
                      // color: Colors.yellow,

                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.yellowAccent),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.yellow,
                      ),
                      child: Column(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Icon(
                            Icons.account_circle,
                            size: 100,
                            color: Colors.black,
                          ),
                          const Divider(
                            thickness: 0.5,
                            color: Colors.black,
                          ),
                          Column(
                            children: [
                              Text(
                                passenger.name.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 28.0,
                                    fontFamily: "Brand Bold"),
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      passenger.phone.toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 28.0,
                                          fontFamily: "Brand Bold"),
                                    )
                                  ],
                                ),
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.email,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      passenger.email.toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 28.0,
                                          fontFamily: "Brand Bold"),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 1,
                );
              },
              itemCount: _filteredPassengers.length)
        ],
      ),
    ]);
  }

  String printDetails(BuildContext context, DataSnapshot snapshot, int index) {
    Map? data = snapshot.value as Map?;
    String name = data!['name'];
    String email = data['email'];
    String phonenumber = data['phone'];
    return "NAME                       :  $name \nEMAIL                       :  $email  \nPHONE NUMBER :  $phonenumber";
  }

  searchMap(String search, context) {
    passengerRef.once().then((snapshot) async {
      passengerMap = await snapshot.snapshot.value as Map<dynamic, dynamic>;

      passengerMap.forEach((key, values) {
        if (values['name'] == search) {
          log(key);
        } else {
          log("no data found $search");
        }
      });
    });

// ---
  }
}
