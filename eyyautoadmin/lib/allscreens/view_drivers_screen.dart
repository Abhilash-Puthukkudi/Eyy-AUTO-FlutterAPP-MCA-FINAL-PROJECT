import 'package:eyyautoadmin/models/drivers_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../functions/validators.dart';

class viewDrivers extends StatefulWidget {
  const viewDrivers({Key? key}) : super(key: key);
  static const String idScreen = "viewDrivers";

  @override
  State<viewDrivers> createState() => _viewDriversState();
}

class _viewDriversState extends State<viewDrivers> {
  List<DriversData> _allDrivers = [];
  List<DriversData> _foundedDrivers = [];

  @override
  void initState() {
    getDrivers();
    super.initState();
  }

  getDrivers() async {
    DatabaseEvent snapshotEvent = await driverRef.once();
    final drivers_data = snapshotEvent.snapshot.value as Map<dynamic, dynamic>;
    List<DriversData> data = [];
    drivers_data.forEach((key, value) {
      data.add(DriversData.fromJson(value));
      // print(value);
    });
    print(_allDrivers);

    setState(() {
      _allDrivers = data
          .where((driver) =>
              driver.status.toString().toLowerCase().contains('accepted'))
          .toList();
      _foundedDrivers = _allDrivers;
      print(_foundedDrivers);
    });
  }

  void _filterDrivers(String enteredKeyword) {
    List<DriversData> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allDrivers;
    } else {
      results = _allDrivers
          .where((emp) => emp.name!
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundedDrivers = results;
    });
  }

  TextEditingController searchTextcontroller = TextEditingController();
  DatabaseReference? searchref;
  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            const SizedBox(
              width: 400,
            ),
            Column(
              children: [
                SizedBox(
                  width: 500,
                ),
                Text("Drivers",
                    style: TextStyle(
                        color: Colors.yellow,
                        fontFamily: "Brand Bold",
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
                Container(
                  width: 500,
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
                        _filterDrivers(value);
                      },
                      controller: searchTextcontroller,
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
                ),
              ],
            ),
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          itemCount: _foundedDrivers.length,
          itemBuilder: (context, index) {
            DriversData driver = _foundedDrivers[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(200, 8, 200, 8),
              child: Container(
                  height: 320,
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
                            driver.name.toString(),
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
                                  driver.phone.toString(),
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
                                  driver.email.toString(),
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
                                  Icons.description,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  driver.autoDetails!.autoNumber.toString(),
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
                                  Icons.contact_mail_sharp,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  driver.autoDetails!.licenceNumber.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 28.0,
                                      fontFamily: "Brand Bold"),
                                )
                              ],
                            ),
                          )
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
        ),
      ]),
    ]);
  }

  // Map DriverData = {};
  // List mydatakeys = [];
  // List mydatavalues = [];
  // String printDetails(BuildContext context, DataSnapshot snapshot, int index) {
  //   mydatakeys.add(snapshot.key);
  //   mydatavalues.add(snapshot.value);

  //   // print(mydatakeys.toString());
  //   Map? data = snapshot.value as Map?;
  //   String name = data!['name'];
  //   String email = data['email'];
  //   String auto_number = data['auto_Details']['auto_number'];
  //   String license_number = data['auto_Details']['licence_number'];
  //   String phonenumber = data['phone'];
  //   return "NAME                            :  $name \nEMAIL                            :  $email  \nPHONE NUMBER      :  $phonenumber  \nAUTO NUMBER         :  $auto_number  \nLICENSE NUMBER   :  $license_number";
  // }
}
