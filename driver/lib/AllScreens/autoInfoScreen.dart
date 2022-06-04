import 'package:driver/AllScreens/loginScreen.dart';
import 'package:driver/functions/configMaps.dart';
import 'package:driver/functions/firebaseReferances.dart';
import 'package:flutter/material.dart';

import '../functions/validators.dart';

class AutoInfoScreen extends StatefulWidget {
  const AutoInfoScreen({Key? key}) : super(key: key);

  static const String idScreen = "autoInfo";

  @override
  State<AutoInfoScreen> createState() => _AutoInfoScreenState();
}

class _AutoInfoScreenState extends State<AutoInfoScreen> {
  TextEditingController autoNumbertextEditingcontroller =
      TextEditingController();
  TextEditingController LicenceNumbertextEditingcontroller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(223, 34, 34, 34),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 22.0,
          ),
          Image.asset(
            'images/driver.png',
            width: 390.0,
            height: 250.0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
            child: Column(
              children: [
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  "Auto Details",
                  style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 28.0,
                      fontFamily: "Brand Bold"),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 18.0,
                ),
                TextField(
                  controller: autoNumbertextEditingcontroller,
                  style: TextStyle(color: Colors.yellow, fontSize: 18),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Auto number",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                      hintStyle: TextStyle(
                          fontSize: 10.0,
                          color: Color.fromARGB(255, 255, 255, 255))),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: LicenceNumbertextEditingcontroller,
                  style: TextStyle(color: Colors.yellow, fontSize: 18),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Licence number",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                      hintStyle: TextStyle(
                          fontSize: 10.0,
                          color: Color.fromARGB(255, 255, 255, 255))),
                ),
                SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: BorderSide(
                                  color: Color.fromARGB(255, 8, 7, 7))))),
                  onPressed: () {
                    if (autoNumbertextEditingcontroller.text.isEmpty) {
                      redMessenger(context, "Enter Auto number  !");
                    } else if (LicenceNumbertextEditingcontroller
                        .text.isEmpty) {
                      redMessenger(context, "Enter License number!");
                    } else {
                      // String autoNumber =
                      //     autoNumbertextEditingcontroller.text.trim();
                      // String licenseNumber =
                      //     LicenceNumbertextEditingcontroller.text.trim();
                      //login function
                      saveDriverAutoinfo(context);
                    }
                  },
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Next",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand Bolt"),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                            size: 25.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }

  void saveDriverAutoinfo(context) {
    String userId = currentFirebaseUSer!.uid;

    Map autoInfoMap = {
      "auto_number": autoNumbertextEditingcontroller.text,
      "licence_number": LicenceNumbertextEditingcontroller.text
    };

    driverRef.child(userId).child("auto_Details").set(autoInfoMap);
    greenMessenger(context, "Auto Details are added. Login to continue.");
    Navigator.pushNamedAndRemoveUntil(
        context, loginScreen.idScreen, (route) => false);
  }
}
