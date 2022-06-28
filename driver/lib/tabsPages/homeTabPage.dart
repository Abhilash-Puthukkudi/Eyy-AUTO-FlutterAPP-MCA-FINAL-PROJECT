import 'dart:async';

import 'package:driver/functions/validators.dart';
import 'package:driver/main.dart';
import 'package:driver/notifications/pushNotifictionService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../functions/configMaps.dart';

class homeTab extends StatefulWidget {
  const homeTab({Key? key}) : super(key: key);

  @override
  State<homeTab> createState() => _homeTabState();
}

class _homeTabState extends State<homeTab> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

// google map camera postion
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
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

    // String address =
    // await assistanceMethods.searchCordinateAddress(position, context);

    // d.log("adress is $address");
    // d.log(address);
  }

  String driverStatusText = "offline Now - Go online";
  Color driverStatusColor = Colors.black;
  Color driverStatusBorderColor = Colors.red;
  bool isDriverAvilable = false;

  @override
  void initState() {
    // TODO: implement initState
    print("init state block excecuted");
    super.initState();
    getCurrentDriverInfo();
  }

  void getCurrentDriverInfo() async {
    currentFirebaseUSer = await FirebaseAuth.instance.currentUser;
    PushNotficationService pushNotficationService = PushNotficationService();
    pushNotficationService.initialize();
    pushNotficationService.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            // zoomGesturesEnabled: true,
            // zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              locateposition();
            },
          ),
          //ONLINE OFLINE DRIVER CONTAINER
          Container(
            height: 144.0,
            width: double.infinity,
            color: Colors.black45,
          ),
          Positioned(
            top: 35.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(driverStatusColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    side: BorderSide(
                                        color: driverStatusBorderColor)))),
                    onPressed: () {
                      if (isDriverAvilable != true) {
                        makeDriverOnlineNow();
                        getLocationLiveUpdates();

                        setState(() {
                          driverStatusColor = Colors.green;
                          driverStatusBorderColor = Colors.greenAccent;
                          driverStatusText = "Online now";
                          isDriverAvilable = true;
                        });
                        greenMessenger(context, "You are online now!!");
                      } else {
                        setState(() {
                          driverStatusColor = Colors.black;
                          driverStatusBorderColor = Colors.redAccent;
                          driverStatusText = "Offline Now - Go online";
                          isDriverAvilable = false;
                        });
                        makeDriverOffline();
                      }
                    },
                    child: Container(
                      height: 78,
                      width: 300,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              driverStatusText,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontFamily: "Brand Bold"),
                            ),
                            Icon(
                              Icons.phone_android,
                              color: Colors.white,
                              size: 25.0,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void makeDriverOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPostiion = position;

    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentFirebaseUSer!.uid, currentPostiion!.latitude,
        currentPostiion!.longitude);
    rideRequestRef.onValue.listen((event) {});
  }

  void getLocationLiveUpdates() {
    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPostiion = position;
      if (isDriverAvilable == true) {
        Geofire.setLocation(
            currentFirebaseUSer!.uid, position.latitude, position.longitude);
      }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void makeDriverOffline() {
    Geofire.removeLocation(currentFirebaseUSer!.uid);
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
    redMessenger(context, "You are offline now!!");
  }
}
