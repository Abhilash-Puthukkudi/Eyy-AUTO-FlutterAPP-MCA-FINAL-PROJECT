import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passenger/DataHandler/appData.dart';
import 'package:passenger/allwidgets/dividerWidget.dart';
import 'package:passenger/assistance/requestAssistance.dart';
import 'package:passenger/functions/configMaps.dart';
import 'package:passenger/models/address.dart';
import 'package:passenger/models/placePredictions.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as d;

class searchScreen extends StatefulWidget {
  const searchScreen({Key? key}) : super(key: key);

  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  TextEditingController pickupTextEditingcontroller = TextEditingController();
  TextEditingController destinationTextEditingcontroller =
      TextEditingController();

  List<PlacePredictions> placePredictionList = [];

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
                            onChanged: (value) {
                              findPlace(value);
                            },
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
          //tile for displaying sugessions
          //
          SizedBox(
            height: 10.0,
          ),
          (placePredictionList.length > 0)
              ? Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListView.separated(
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context, index) {
                      return predictionTile(
                        placePredictions: placePredictionList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        DividorWidget(),
                    itemCount: placePredictionList.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapkey&sessiontoken=1234567890&components=country:in";
      var res = await requestAssistant.getRequest(autoCompleteUrl);
      if (res == "failed") {
        return;
      }
      if (res["status"] == "OK") {
        var predictions = res["predictions"];
        var placesList = (predictions as List)
            .map((e) => PlacePredictions.fromjson(e))
            .toList();

        setState(() {
          placePredictionList = placesList;
        });
      }
    }
  }
}

class predictionTile extends StatelessWidget {
  final PlacePredictions? placePredictions;
  const predictionTile({Key? key, this.placePredictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Container(
        child: Column(
          children: [
            SizedBox(
              width: 10.0,
            ),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(
                  width: 14.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        placePredictions!.main_text.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Text(placePredictions!.secondary_text.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            fontSize: 12.0,
                            color: Colors.grey,
                          )),
                      SizedBox(
                        height: 8.0,
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(width: 10.0)
          ],
        ),
      ),
    );
  }

  void getplaceDetails(String placeID, context) async {
    String placeDetailsURL =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$mapkey";

    var res = await requestAssistant.getRequest(placeDetailsURL);

    if (res == "failed") {
      return;
    }
    if (res["status"] == "OK") {
      Address address = Address();
      address.placeName = res["result"]["name"];
      address.placeid = placeID;
      address.lattitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];

      Provider.of<appData>(context, listen: false)
          .updateDropOffLocationAddress(address);

      d.log("this is the address ");
      d.log(address.placeName.toString());
    }
  }
}
