import 'dart:async';
import 'dart:developer' as d;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passenger/AllScreens/loginScreen.dart';
import 'package:passenger/AllScreens/searchScreen.dart';
import 'package:passenger/DataHandler/appData.dart';
import 'package:passenger/allwidgets/progressWidget.dart';
import 'package:passenger/assistance/assistanceMethods.dart';
import 'package:passenger/functions/configMaps.dart';
import 'package:passenger/functions/validators.dart';
import 'package:provider/provider.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({Key? key}) : super(key: key);

  static const String idScreen = "mainScreen";

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> with TickerProviderStateMixin {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  var tripdirectionDetails;

//polyline
  List<LatLng> polyLineCordinates = [];
  Set<Polyline> polyLineSet = {};
//polyline end
  double BottompaddingOfMap = 0.0;

  // markers for map
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  double rideDetailsContainerHeight = 0;
  double requestRideContainerHeight = 0;
  double searchContainerHeight = 250.0;
  bool drawerOpen = true;

  DatabaseReference? rideRequestRef;

  // calling userinfo function to get user information

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    assistanceMethods.getCurrentOnlineUserInformation();
  }
  // end of user info function

  // saving ride request
  void saveRideRequest() {
    rideRequestRef = FirebaseDatabase.instance.ref().child("Ride Requests");
    var pickUp = Provider.of<appData>(context, listen: false).pickUpLocation;
    var dropOff = Provider.of<appData>(context, listen: false).dropOffLocation;

    Map pickUpLocationMap = {
      "latitude": pickUp!.lattitude.toString(),
      "longitude": pickUp.longitude.toString()
    };

    Map dropOffLocationMap = {
      "latitude": dropOff!.lattitude.toString(),
      "longitude": dropOff.longitude.toString()
    };

    Map riderInfoMap = {
      "driver_id": "waitting",
      "payment_method": "cash",
      "pickup": pickUpLocationMap,
      "dropoff": dropOffLocationMap,
      "created_at": DateTime.now().toString(),
      "rider_name": userCurrentInfo!.name,
      "rider_phone": userCurrentInfo!.phone,
      "pickup_address": pickUp.placeName,
      "dropoff_address": dropOff.placeName,
    };

    rideRequestRef!.push().set(riderInfoMap);
  }
// end of save ride request

  void displayRequestRideContainer() {
    setState(() {
      requestRideContainerHeight = 250.0;
      rideDetailsContainerHeight = 0.0;
      BottompaddingOfMap = 255;
      drawerOpen = true;
    });
    saveRideRequest();
  }

  resetApp() {
    setState(() {
      drawerOpen = true;
      searchContainerHeight = 250;
      rideDetailsContainerHeight = 0.0;
      BottompaddingOfMap = 255;

      polyLineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      polyLineCordinates.clear();
    });

    locateposition();
  }

  void displayRideDetailsContainer() async {
    await getPlaceDirection();
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 250.0;
      BottompaddingOfMap = 255;
      drawerOpen = false;
    });
  }

// geolocation block
  Position? currentPostiion;

  var geoLocator = Geolocator();

  void locateposition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPostiion = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 15);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address =
        await assistanceMethods.searchCordinateAddress(position, context);

    d.log("adress is $address");
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
              polylines: polyLineSet,
              markers: markersSet,
              circles: circlesSet,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                // locate position starts
                locateposition();
                // locate position block ends

                //  padding
                BottompaddingOfMap = 240.0;
                //
              },
            ),
            Positioned(
              top: 35.0,
              left: 22.0,
              child: GestureDetector(
                onTap: () {
                  if (drawerOpen) {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, loginScreen.idScreen, ((route) => false));
                    greenMessenger(context, "Logout Sucessfull !");
                  } else {
                    resetApp();
                  }
                },
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
                    backgroundColor: Color.fromRGBO(252, 249, 64, 1),
                    child: Icon(
                      (drawerOpen) ? Icons.menu : Icons.close,
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
                child: AnimatedSize(
                  duration: new Duration(milliseconds: 160),
                  curve: Curves.bounceIn,
                  child: Container(
                    height: searchContainerHeight,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 6.0,
                          ),
                          Text(
                            "Hi There, ",
                            style: TextStyle(
                                fontSize: 15.0, fontFamily: "Brand Bold"),
                          ),
                          Text(
                            "Where are you going ? ",
                            style: TextStyle(
                                fontSize: 22.0, fontFamily: "Brand Bold"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              var res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => searchScreen()));

                              if (res == "obtainedDirection") {
                                // await getPlaceDirection();
                                displayRideDetailsContainer();
                                d.log("here reaching");
                              }
                            },
                            child: Container(
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
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 20.0,
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
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.lato(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )),
            //fare screen
            Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: AnimatedSize(
                  curve: Curves.bounceIn,
                  duration: new Duration(milliseconds: 160),
                  child: Container(
                    height: rideDetailsContainerHeight,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(223, 34, 34, 34),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              blurRadius: 16.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7))
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 17.0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            color: Colors.yellowAccent,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "images/autorickshaw.png",
                                    height: 70.0,
                                    width: 80.0,
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Auto",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontFamily: "Brand-Bold")),
                                      Text(
                                          ((tripdirectionDetails != null)
                                              ? tripdirectionDetails
                                                  .distanceText
                                                  .toString()
                                              : ''),
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontFamily: "Brand Bold",
                                              color: Colors.grey)),
                                    ],
                                  ),
                                  Expanded(child: Container()),
                                  Text(
                                      ((tripdirectionDetails != null
                                          ? '\₹${assistanceMethods.calculateFares(tripdirectionDetails)[0]}'
                                          : '')),
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: "Brand Bold",
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.clock,
                                  size: 18.0,
                                  color: Colors.yellow,
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Text(
                                  (tripdirectionDetails != null)
                                      ? "Estimated Travel Time : ${assistanceMethods.calculateFares(tripdirectionDetails)[1]}"
                                      : '',
                                  style: TextStyle(color: Colors.yellow),
                                ),
                                SizedBox(
                                  width: 6.0,
                                ),
                                // Icon(
                                //   Icons.keyboard_arrow_down,
                                //   color: Colors.yellow,
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                d.log("print");
                                displayRequestRideContainer();
                              },
                              child: Padding(
                                padding: EdgeInsets.all(17.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Request Ride",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(
                                      FontAwesomeIcons.hand,
                                      color: Colors.black,
                                      size: 26.0,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),

            // request wait panel

            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0)),
                    color: Color.fromARGB(255, 249, 246, 68),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 0.5,
                          blurRadius: 16.0,
                          color: Colors.black,
                          offset: Offset(0.7, 0.7))
                    ]),
                height: requestRideContainerHeight,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 18.0,
                      ),
                      // animated text
                      SizedBox(
                        width: double.infinity,
                        child: AnimatedTextKit(
                          animatedTexts: [
                            ColorizeAnimatedText(
                              'Requesting a Ride..',
                              textStyle: colorizeTextStyle,
                              textAlign: TextAlign.center,
                              colors: colorizeColors,
                            ),
                            ColorizeAnimatedText(
                              'Please Wait...',
                              textStyle: colorizeTextStyle,
                              textAlign: TextAlign.center,
                              colors: colorizeColors,
                            ),
                            ColorizeAnimatedText(
                              'Finding a driver..',
                              textAlign: TextAlign.center,
                              textStyle: colorizeTextStyle,
                              colors: colorizeColors,
                            ),
                          ],
                          isRepeatingAnimation: true,
                          onTap: () {
                            print("Tap Event");
                          },
                        ),
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(252, 249, 64, 1),
                          borderRadius: BorderRadius.circular(26.0),
                          border: Border.all(width: 2.0, color: Colors.black),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 26.0,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          "Cancel Ride",
                          textAlign: TextAlign.center,
                        ),
                      )

                      // animated text end
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    var initialpos =
        Provider.of<appData>(context, listen: false).pickUpLocation;
    var finalpos = Provider.of<appData>(context, listen: false).dropOffLocation;
    // d.log(initialpos!.lattitude.toString());

    var pickUpLapLng = LatLng(
        initialpos!.lattitude!.toDouble(), initialpos.longitude!.toDouble());

    var dropOffLapLng =
        LatLng(finalpos!.lattitude!.toDouble(), finalpos.longitude!.toDouble());

    showDialog(
        context: context,
        builder: (BuildContext context) => progressBar("Please wait.."));

    var details = await assistanceMethods.obtainPlaceDirectionDetails(
        pickUpLapLng, dropOffLapLng);
    setState(() {
      tripdirectionDetails = details;
    });
    Navigator.pop(context);
    d.log("THIS IS THE DATA U NEED ");
    d.log(details.encodedPoints.toString());
    // polyline ploting

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints.toString());

    polyLineCordinates.clear(); //clearing polylinecordinates list

    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        polyLineCordinates.add(LatLng(pointLatLng.latitude,
            pointLatLng.longitude)); // adding cordinates to the list
      });
    }
    polyLineSet.clear(); // clearing polyline set before adding polylines
    setState(() {
      Polyline polyline = Polyline(
          color: Colors.black,
          polylineId: PolylineId("PolylineID"),
          jointType: JointType.round,
          points: polyLineCordinates,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);

      polyLineSet.add(polyline); // adding polyline to set
    });
//  setting polyline camera view
    LatLngBounds latLngBounds;
    if (pickUpLapLng.latitude > dropOffLapLng.latitude &&
        pickUpLapLng.longitude > dropOffLapLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLapLng, northeast: pickUpLapLng);
    } else if (pickUpLapLng.longitude > dropOffLapLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLapLng.latitude, dropOffLapLng.longitude),
          northeast: LatLng(dropOffLapLng.latitude, pickUpLapLng.longitude));
    } else if (pickUpLapLng.latitude > dropOffLapLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLapLng.latitude, pickUpLapLng.longitude),
          northeast: LatLng(pickUpLapLng.latitude, dropOffLapLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLapLng, northeast: dropOffLapLng);
    }

    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    // setting markers for map

    Marker pickupLocationMarker = Marker(
      markerId: MarkerId("pickupID"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow:
          InfoWindow(title: initialpos.placeName, snippet: "My Location"),
      position: pickUpLapLng,
    );

    Marker dropOffLocationMarker = Marker(
      markerId: MarkerId("dropOffID"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
          title: finalpos.placeName, snippet: "Destination Location"),
      position: dropOffLapLng,
    );

    setState(() {
      markersSet.add(pickupLocationMarker);
      markersSet.add(dropOffLocationMarker);
    });

    Circle pickUpLocCircle = Circle(
      circleId: CircleId("pickupID"),
      fillColor: Colors.yellow,
      center: pickUpLapLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.black,
    );

    Circle dropOffLocCircle = Circle(
      circleId: CircleId("dropOffID"),
      fillColor: Colors.deepPurple,
      center: dropOffLapLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.purple,
    );

    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
  }
}
