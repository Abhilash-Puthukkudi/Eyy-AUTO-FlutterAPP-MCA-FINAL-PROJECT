import 'dart:ffi';
import 'dart:ui';

import 'package:driver/AllScreens/loginScreen.dart';
import 'package:driver/allwidgets/progressWidget.dart';
import 'package:driver/functions/configMaps.dart';
import 'package:driver/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellowAccent,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              driversInformation!.name.toString(),
              style: TextStyle(
                  fontSize: 100.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Signatra"),
            ),
            Text(
              "Best Driver",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.blueGrey,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.bold,
                  fontFamily: " Brand Regular"),
            ),
            SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            InfoCard(
              icon: Icons.phone,
              onPresed: () async {},
              text: driversInformation!.phone.toString(),
            ),
            InfoCard(
              icon: Icons.email,
              onPresed: () async {},
              text: driversInformation!.email.toString(),
            ),
            InfoCard(
              icon: Icons.rectangle_outlined,
              onPresed: () async {},
              text: driversInformation!.auto_number.toString(),
            ),
            InfoCard(
              icon: Icons.book,
              onPresed: () async {},
              text: driversInformation!.licence_number.toString(),
            ),
            GestureDetector(
              onTap: () async {
                progressBar("Loging out..");
                await Geofire.removeLocation(currentFirebaseUSer!.uid);
                rideRequestRef.onDisconnect();
                rideRequestRef.remove();
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, loginScreen.idScreen, (route) => false);
              },
              child: Card(
                color: Colors.redAccent,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 110.0),
                child: ListTile(
                    leading: Icon(
                      Icons.logout_outlined,
                      color: Colors.black87,
                    ),
                    title: Text(
                      "Sign out",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16.0,
                        fontFamily: "Brand Bold",
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String text;
  final IconData icon;
  void Function()? onPresed;
  InfoCard({required this.icon, required this.onPresed, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPresed,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
            leading: Icon(
              icon,
              color: Colors.black87,
            ),
            title: Text(
              text,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16.0,
                fontFamily: "Brand Bold",
              ),
            )),
      ),
    );
  }
}
