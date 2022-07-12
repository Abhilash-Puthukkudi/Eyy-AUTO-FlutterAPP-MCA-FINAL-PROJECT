import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:passenger/AllScreens/mainScreen.dart';
import 'package:passenger/AllScreens/registrationScreen.dart';
import 'package:passenger/allwidgets/progressWidget.dart';
import 'package:passenger/assistance/assistanceMethods.dart';
import 'package:passenger/functions/configMaps.dart';
import 'package:passenger/functions/firebaseReferances.dart';
import 'package:passenger/functions/validators.dart';

class resetpassword extends StatefulWidget {
  const resetpassword({Key? key}) : super(key: key);

  static const String idScreen = "reset";

  @override
  State<resetpassword> createState() => _resetpasswordState();
}

class _resetpasswordState extends State<resetpassword> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  //text editing controllers

  final TextEditingController usernameController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(223, 34, 34, 34),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 70.0),
            Image(
              image: AssetImage("images/icon.png"),
              width: 390,
              height: 250,
              alignment: Alignment.center,
            ),
            SizedBox(height: 10.0),
            Text(
              "Enter registerd email address ",
              style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 28.0,
                  fontFamily: "Brand Bold"),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  SizedBox(height: 1.0),
                  TextField(
                    controller: usernameController,
                    style: TextStyle(color: Colors.yellow, fontSize: 18),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                        hintStyle: TextStyle(
                            fontSize: 10.0,
                            color: Color.fromARGB(255, 255, 255, 255))),
                  ),
                  SizedBox(height: 5.0),
                  // TextField(
                  //   controller: passwordController,
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(color: Colors.yellow, fontSize: 18),
                  //   obscureText: true,
                  //   decoration: InputDecoration(
                  //       border: OutlineInputBorder(),
                  //       labelText: "Password",
                  //       labelStyle:
                  //           TextStyle(fontSize: 14.0, color: Colors.white),
                  //       hintStyle:
                  //           TextStyle(fontSize: 10.0, color: Colors.grey)),
                  // ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    side: BorderSide(
                                        color: Color.fromARGB(255, 8, 7, 7))))),
                    onPressed: () {
                      if (usernameController.text.isEmpty) {
                        redMessenger(context, "Enter Username  to login!");
                      } else {
                        String username = usernameController.text.trim();
                        // String password = passwordController.text.trim();
                        //login function
                        log(username.toString());

                        resetPassword(context, username);
                      }
                    },
                    child: Container(
                      height: 50,
                      child: Center(
                        child: Text(
                          "Send reset email",
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "Brand Bolt"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // TextButton(
            //     onPressed: () {
            //       Navigator.pushNamedAndRemoveUntil(
            //           context, registrationScreen.idScreen, (route) => false);
            //     },
            //     child: Text(
            //       "Do not have an Account? Register Here.",
            //       style: TextStyle(
            //           color: Colors.yellow,
            //           fontSize: 14.0,
            //           fontFamily: "Brand Bold"),
            //       textAlign: TextAlign.center,
            //     ))
          ],
        ),
      ),
    );
  }

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void resetPassword(BuildContext context, String username) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: username);
      greenMessenger(context, "Please check your email for password rest link");
    } catch (e) {
      redMessenger(context, "Error occurd");
    }
  }
}
