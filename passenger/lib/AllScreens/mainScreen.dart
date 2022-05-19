import 'dart:async';
import 'dart:ffi';
import 'dart:developer' as d;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passenger/DataHandler/appData.dart';
import 'package:passenger/assistance/assistanceMethods.dart';
import 'package:provider/provider.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({Key? key}) : super(key: key);

  static const String idScreen = "mainScreen";

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  double BottompaddingOfMap = 0.0;

// geolocation block
  Position? currentPostiion;

  var geoLocator = Geolocator();

  void locateposition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPostiion = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address =
        await assistanceMethods.searchCordinateAddress(position, context);

    print("adress is $address");
    d.log(address);
  }

//

// google map camera postion
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GoogleMapController? newGoogleMapController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: BottompaddingOfMap),
              initialCameraPosition: _kGooglePlex,
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                // locate position starts
                locateposition();
                // locate position block ends

                //  padding
                BottompaddingOfMap = 265.0;
                //
              },
            ),
            Positioned(
              top: 35.0,
              left: 22.0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(22.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 6.0,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7))
                      ]),
                  child: CircleAvatar(
                    backgroundColor: Colors.yellow,
                    child: Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                    radius: 20.0,
                  ),
                ),
              ),
            ),
            Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(252, 249, 64, 1),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18.0),
                          topRight: Radius.circular(18.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(255, 1, 1, 1),
                            blurRadius: 16.0,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7))
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 18.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 6.0,
                        ),
                        Text(
                          "Hi There, ",
                          style: TextStyle(fontSize: 15.0),
                        ),
                        Text(
                          "Where are you going ? ",
                          style: TextStyle(
                              fontSize: 22.0, fontFamily: "Brand Bold"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 6.0,
                                    spreadRadius: 0.5,
                                    offset: Offset(0.7, 0.7))
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Search Destination",
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24.0,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 24.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Provider.of<appData>(context)
                                              .pickUpLocation !=
                                          null
                                      ? Provider.of<appData>(context)
                                          .pickUpLocation!
                                          .placeName
                                          .toString()
                                      : "Fetching pickup Location",
                                  overflow: TextOverflow.visible,
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
