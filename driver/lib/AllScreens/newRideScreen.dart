import 'dart:async';
import 'dart:developer';

import 'package:driver/allwidgets/collectFareDialouge.dart';
import 'package:driver/allwidgets/progressWidget.dart';
import 'package:driver/assistance/assistanceMethods.dart';
import 'package:driver/assistance/mapKitAssistant.dart';
import 'package:driver/functions/configMaps.dart';
import 'package:driver/functions/firebaseReferances.dart';
import 'package:driver/models/rideDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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

  var geoLocator = Geolocator();
  var locationOptions = LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
  );
  BitmapDescriptor? animatingMarkerIcon;

  Position? myposition;
  String status = "accepted";
  String durationRide = " ";
  bool isRequestingDirection = false;
  String btntitle = "Arrived";
  Color btnColor = Colors.black;
  Timer? timer;
  int durationCounter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    acceptRideRequest();
  }

  void createIconMarker() {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: Size(2, 2));
    BitmapDescriptor.fromAssetImage(
            imageConfiguration, "images/automarkerfinal.png")
        .then((value) {
      animatingMarkerIcon = value;
    });
  }

  void getRideLiveLocationupdates() {
    LatLng oldPos = LatLng(0, 0);

    rideStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPostiion = position;
      myposition = position;
      LatLng mPosition = LatLng(position.latitude, position.longitude);

      var rotation = MapKitAssistant.getMarkerRotaion(oldPos.latitude,
          oldPos.longitude, mPosition.latitude, mPosition.longitude);

      Marker animatingMarker = Marker(
          markerId: MarkerId("animating"),
          position: mPosition,
          icon: animatingMarkerIcon as BitmapDescriptor,
          rotation: rotation,
          infoWindow: InfoWindow(title: "Current postion"));

      setState(() {
        CameraPosition cameraPosition =
            new CameraPosition(target: mPosition, zoom: 17);
        newRideGoogleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        // adding animated marker with live updation first removing and then updating
        markersSet
            .removeWhere((marker) => marker.markerId.value == "animating");
        markersSet.add(animatingMarker);
      });

      String rideRequestId = widget.rideDetails!.rideRequest_id.toString();

      updateRideDetails();
      Map locMap = {
        "latitude": currentPostiion!.latitude.toString(),
        "longitude": currentPostiion!.longitude.toString(),
      };

      newRideRequestRef
          .child(rideRequestId)
          .child("driver_location")
          .set(locMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    createIconMarker();
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
                // calling live location updating fucntion
                getRideLiveLocationupdates();
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
                        durationRide,
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
                            widget.rideDetails!.riderName.toString(),
                            style: TextStyle(
                              fontFamily: "Brand Bold",
                              fontSize: 24.0,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: GestureDetector(
                                  onTap: () {
                                    // openDialPad(widget.rideDetails!.riderPhone
                                    //     .toString());
                                  },
                                  child: Icon(Icons.call))),
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
                              widget.rideDetails!.pickup_address.toString(),
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
                              widget.rideDetails!.dropoff_address.toString(),
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
                            onPressed: () async {
                              if (status == "accepted") {
                                status = "arrived";
                                String rideRequestID = widget
                                    .rideDetails!.rideRequest_id
                                    .toString();
                                newRideRequestRef
                                    .child(rideRequestID)
                                    .child("status")
                                    .set(status);
                                setState(() {
                                  btntitle = "Start Trip";
                                  btnColor = Colors.blueAccent;
                                });
// please wait dialogue
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) =>
                                        progressBar("Please Wait.."));

                                // drwaing new polyline on map to the destination
                                await getPlaceDirection(
                                    widget.rideDetails!.pickUp as LatLng,
                                    widget.rideDetails!.dropOff as LatLng);

                                Navigator.pop(context);
                              } else if (status == "arrived") {
                                status = "onride";
                                String rideRequestID = widget
                                    .rideDetails!.rideRequest_id
                                    .toString();
                                newRideRequestRef
                                    .child(rideRequestID)
                                    .child("status")
                                    .set(status);
                                setState(() {
                                  btntitle = "End Trip";
                                  btnColor = Colors.redAccent;
                                });
                                initTimer();
                              } else if (status == "onride") {
                                endTheTrip();
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  btntitle,
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
                                primary: btnColor,
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

    driverRef
        .child(currentFirebaseUSer!.uid)
        .child("history")
        .child(rideRequestId)
        .set(true);
  }

  Future<void> updateRideDetails() async {
    if (isRequestingDirection == false) {
      isRequestingDirection = true;
      if (myposition == null) {
        return;
      }
      var posLatLng = LatLng(myposition!.latitude, myposition!.longitude);
      LatLng destinationLatLang;
      if (status == "accepted") {
        destinationLatLang = widget.rideDetails!.pickUp as LatLng;
      } else {
        destinationLatLang = widget.rideDetails!.dropOff as LatLng;
      }
      var directionDetails = await assistanceMethods
          .obtainPlaceDirectionDetails(posLatLng, destinationLatLang);
      if (directionDetails != null) {
        setState(() {
          durationRide = directionDetails.durationText.toString();
        });
      }
      isRequestingDirection = false;
    }
  }

  void initTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter = durationCounter + 1;
    });
  }

  void endTheTrip() async {
    timer!.cancel();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => progressBar("Please Wait.."));

    var currentLatLng = LatLng(myposition!.latitude, myposition!.longitude);
    var directionalDetails =
        await assistanceMethods.obtainPlaceDirectionDetails(
            widget.rideDetails!.pickUp as LatLng, currentLatLng);

    Navigator.pop(context);
    var fareAmountList = assistanceMethods.calculateFares(directionalDetails);
    var fareAmount = fareAmountList[0];

    String rideRequestID = widget.rideDetails!.rideRequest_id.toString();
    newRideRequestRef
        .child(rideRequestID)
        .child("fares")
        .set(fareAmount.toString());
    newRideRequestRef.child(rideRequestID).child("status").set("ended");
    rideStreamSubscription!.cancel();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            CollectFareDialog(paymentMethod: "", fareAmount: fareAmount));

    saveEarnings(fareAmount);
  }

  void saveEarnings(int fareAmount) {
    driverRef
        .child(currentFirebaseUSer!.uid)
        .child("earnings")
        .once()
        .then((datasnapshot) {
      if (datasnapshot.snapshot.value != null) {
        double oldEarnings =
            double.parse(datasnapshot.snapshot.value.toString());
        double totalEarnings = oldEarnings + fareAmount;

        driverRef
            .child(currentFirebaseUSer!.uid)
            .child("earnings")
            .set(totalEarnings.toStringAsFixed(2));
      } else {
        double totalEarnings = fareAmount.toDouble();
        driverRef
            .child(currentFirebaseUSer!.uid)
            .child("earnings")
            .set(totalEarnings.toStringAsFixed(2));
      }
    });
  }

  // void openDialPad(String phoneNumber) async {
  //   Uri url = Uri(scheme: "tel", path: phoneNumber);
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   } else {
  //     print("Can't open dial pad.");
  //   }
  // }
}
