import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../functions/configMaps.dart';

class ratingTab extends StatefulWidget {
  const ratingTab({Key? key}) : super(key: key);

  @override
  State<ratingTab> createState() => _ratingTabState();
}

class _ratingTabState extends State<ratingTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: EdgeInsets.all(5.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 22.0),
              Text(
                "Your Ratting",
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

              AbsorbPointer(
                absorbing: true,
                child: SmoothStarRating(
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
              ),

              Text(
                title.toString(),
                style: TextStyle(
                    fontSize: 55.0,
                    fontFamily: "Signatra",
                    color: Colors.yellow),
              ),
              SizedBox(height: 16.0),

              // button goes here

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
