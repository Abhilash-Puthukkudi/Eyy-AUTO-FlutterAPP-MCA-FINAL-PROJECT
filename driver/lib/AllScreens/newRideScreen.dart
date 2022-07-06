import 'dart:async';
import 'dart:developer';

import 'package:driver/allwidgets/progressWidget.dart';
import 'package:driver/assistance/assistanceMethods.dart';
import 'package:driver/functions/configMaps.dart';
import 'package:driver/functions/firebaseReferances.dart';
import 'package:driver/models/rideDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class newRideScreen extends StatefulWidget {
  // const newRideScreen({Key? key}) : super(key: key);
  final RideDetails? rideDetails;
  newRideScreen({this.rideDetails});

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  State<newRideScreen> createState() => _newRideScreenState();
}

class _newRideScreenState extends State<newRideScreen> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newRideGoogleMapController;

  Set<Marker> markersSet = Set<Marker>();
  Set<Circle> circleSet = Set<Circle>();
  Set<Polyline> polylineSet = Set<Polyline>();
  List<LatLng> polylineCordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double mapPaddingFromBotton = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    acceptRideRequest();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: mapPaddingFromBotton),
              initialCameraPosition: newRideScreen._kGooglePlex,
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              markers: markersSet,
              circles: circleSet,
              polylines: polylineSet,
              // zoomGesturesEnabled: true,
              // zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) async {
                _controllerGoogleMap.complete(controller);
                newRideGoogleMapController = controller;
                setState(() {
                  mapPaddingFromBotton = 265.0;
                });
                var currentLatlang = LatLng(
                    currentPostiion!.latitude, currentPostiion!.longitude);
                var pickupLatlang = widget.rideDetails!.pickUp;
                await getPlaceDirection(
                    currentLatlang, pickupLatlang as LatLng);
              },
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      )
                    ]),
                height: 260.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 18.0),
                  child: Column(
                    children: [
                      Text(
                        "10 minutes",
                        style: TextStyle(
                            fontFamily: "Brand Bold",
                            fontSize: 18.0,
                            color: Colors.deepPurple),
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Abhilash Puthukkudi",
                            style: TextStyle(
                              fontFamily: "Brand Bold",
                              fontSize: 24.0,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: Icon(Icons.call)),
                        ],
                      ),
                      SizedBox(
                        height: 26.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/pickicon.png",
                            height: 16.0,
                            width: 16.0,
                          ),
                          SizedBox(
                            width: 18.0,
                          ),
                          Expanded(
                              child: Container(
                            child: Text(
                              "Chelavoor kozhikode 673571",
                              style: TextStyle(fontSize: 18.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/desticon.png",
                            height: 16.0,
                            width: 16.0,
                          ),
                          SizedBox(
                            width: 18.0,
                          ),
                          Expanded(
                              child: Container(
                            child: Text(
                              "kunnamnagalam,kozhikode,673571",
                              style: TextStyle(fontSize: 18.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 26.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Arrived",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Icon(
                                  Icons.directions_railway_sharp,
                                  color: Colors.white,
                                  size: 26.0,
                                )
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                      )
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

  Future<void> getPlaceDirection(
      LatLng pickUpLapLng, LatLng dropOffLapLng) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => progressBar("Please wait.."));

    var details = await assistanceMethods.obtainPlaceDirectionDetails(
        pickUpLapLng, dropOffLapLng);
    ;
    Navigator.pop(context);
    log("THIS IS THE DATA U NEED :  ");
    log(details.encodedPoints.toString());
    // polyline ploting

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints.toString());

    polylineCordinates.clear(); //clearing polylinecordinates list

    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        polylineCordinates.add(LatLng(pointLatLng.latitude,
            pointLatLng.longitude)); // adding cordinates to the list
      });
    }
    polylineSet.clear(); // clearing polyline set before adding polylines
    setState(() {
      Polyline polyline = Polyline(
          color: Colors.black,
          polylineId: PolylineId("PolylineID"),
          jointType: JointType.round,
          points: polylineCordinates,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);

      polylineSet.add(polyline); // adding polyline to set
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

    newRideGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    // setting markers for map

    Marker pickupLocationMarker = Marker(
      markerId: MarkerId("pickupID"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      position: pickUpLapLng,
    );

    Marker dropOffLocationMarker = Marker(
      markerId: MarkerId("dropOffID"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
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
      circleSet.add(pickUpLocCircle);
      circleSet.add(dropOffLocCircle);
    });
  }

  void acceptRideRequest() {
    String rideRequestId = widget.rideDetails!.rideRequest_id.toString();
    newRideRequestRef.child(rideRequestId).child("status").set("accepted");
    newRideRequestRef
        .child(rideRequestId)
        .child("driver_name")
        .set(driversInformation!.name.toString());
    newRideRequestRef
        .child(rideRequestId)
        .child("driver_phone")
        .set(driversInformation!.phone.toString());
    newRideRequestRef
        .child(rideRequestId)
        .child("driver_id")
        .set(driversInformation!.id);
    newRideRequestRef.child(rideRequestId).child("auto_details").set(
        "${driversInformation!.auto_number} - ${driversInformation!.licence_number}");

    Map locMap = {
      "latitude": currentPostiion!.latitude.toString(),
      "longitude": currentPostiion!.longitude.toString(),
    };

    newRideRequestRef.child(rideRequestId).child("driver_location").set(locMap);
  }
}
