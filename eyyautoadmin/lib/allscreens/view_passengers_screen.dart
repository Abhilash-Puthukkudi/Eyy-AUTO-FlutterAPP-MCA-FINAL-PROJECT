import 'dart:developer';

import 'package:eyyautoadmin/functions/validators.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              const SizedBox(
                width: 500,
              ),
              Container(
                width: 500,
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
                child: Text("View Passenger",
                    style: TextStyle(
                        color: Colors.yellow,
                        fontFamily: "Brand Bold",
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SingleChildScrollView(
            child: FirebaseAnimatedList(
              query: passengerRef,
              shrinkWrap: true,
              itemBuilder: (context, snapshot, animation, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 130,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor: Colors.yellow,
                        title: Row(
                          children: [
                            Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                  fontFamily: "Brand Bold",
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.account_circle,
                              size: 70,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              printDetails(context, snapshot, index),
                              style: TextStyle(
                                fontFamily: "Brand Bold",
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
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
