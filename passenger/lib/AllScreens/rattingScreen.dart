import 'package:firebase_database/firebase_database.dart';
import 'package:passenger/assistance/assistanceMethods.dart';
import 'package:flutter/material.dart';
import 'package:passenger/functions/configMaps.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class RattingScreen extends StatefulWidget {
  final String driverID;

  RattingScreen({required this.driverID});

  @override
  State<RattingScreen> createState() => _RattingScreenState();
}

class _RattingScreenState extends State<RattingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: EdgeInsets.all(5.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 22.0),
              Text(
                "Rate this Driver",
                style: TextStyle(
                    fontFamily: "Brand Bold",
                    fontSize: 18.0,
                    color: Colors.green),
              ),
              SizedBox(height: 22.0),
              Divider(),
              SizedBox(
                height: 16.0,
              ),

              SmoothStarRating(
                rating: startCounter,
                color: Colors.yellow,
                allowHalfRating: true,
                starCount: 5,
                size: 45,
                onRatingChanged: (value) {
                  startCounter = value;
                  title = "";
                  if (startCounter == 1) {
                    setState(() {
                      title = "very bad";
                    });
                  } else if (startCounter == 2) {
                    setState(() {
                      title = "bad";
                    });
                  } else if (startCounter == 3) {
                    setState(() {
                      title = "good";
                    });
                  } else if (startCounter == 4) {
                    setState(() {
                      title = "Very Good";
                    });
                  } else if (startCounter == 5) {
                    setState(() {
                      title = "Excellent";
                    });
                  }
                },
              ),

              Text(
                title,
                style: TextStyle(
                    fontSize: 55.0,
                    fontFamily: "Signatra",
                    color: Colors.yellow),
              ),
              SizedBox(height: 16.0),

              // button goes here
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                    onPressed: () {
                      DatabaseReference driverRatingRef = FirebaseDatabase
                          .instance
                          .ref()
                          .child("drivers")
                          .child(widget.driverID)
                          .child("ratings");

                      driverRatingRef.once().then((snapshot) {
                        if (snapshot.snapshot.value != null) {
                          double oldRattings =
                              double.parse(snapshot.snapshot.value.toString());
                          double addratings = oldRattings + startCounter;
                          double averageRattings = addratings / 2;
                          driverRatingRef.set(averageRattings.toString());
                        } else {
                          driverRatingRef.set(startCounter.toString());
                        }
                      });

                      Navigator.pop(context);
                    },
                    child: Text("submit"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.yellow,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
              ),
              SizedBox(
                height: 30.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
