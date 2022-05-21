import 'package:flutter/material.dart';
import 'package:passenger/DataHandler/appData.dart';
import 'package:provider/provider.dart';

class searchScreen extends StatefulWidget {
  const searchScreen({Key? key}) : super(key: key);

  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  TextEditingController pickupTextEditingcontroller = TextEditingController();
  TextEditingController destinationTextEditingcontroller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    String placeAddress =
        Provider.of<appData>(context).pickUpLocation?.placeName ?? "";
    pickupTextEditingcontroller.text = placeAddress;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215.0,
            decoration: BoxDecoration(
                color: Color.fromRGBO(252, 249, 64, 1),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 27, 27, 27),
                      blurRadius: 6.0,
                      spreadRadius: 0.6,
                      offset: Offset(0.7, 07))
                ]),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 25.0, top: 40.0, right: 25.0, bottom: 20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 5.0,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)),
                      Center(
                        child: Text(
                          "Choose Destination",
                          style: TextStyle(
                              fontFamily: "Brand Bold", fontSize: 18.0),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      Image.asset("images/pickicon.png",
                          height: 20.0, width: 20.0),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            controller: pickupTextEditingcontroller,
                            decoration: InputDecoration(
                                fillColor: Colors.grey,
                                hintText: "Pickup Location",
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 11.0, top: 8.0, bottom: 8.0)),
                          ),
                        ),
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Image.asset("images/desticon.png",
                          height: 20.0, width: 20.0),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            controller: destinationTextEditingcontroller,
                            decoration: InputDecoration(
                                fillColor: Colors.grey,
                                hintText: "Where to?",
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 11.0, top: 8.0, bottom: 8.0)),
                          ),
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
