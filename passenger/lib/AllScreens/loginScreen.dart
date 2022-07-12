import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:passenger/AllScreens/mainScreen.dart';
import 'package:passenger/AllScreens/registrationScreen.dart';
import 'package:passenger/AllScreens/resetpassword.dart';
import 'package:passenger/allwidgets/progressWidget.dart';
import 'package:passenger/assistance/assistanceMethods.dart';
import 'package:passenger/functions/configMaps.dart';
import 'package:passenger/functions/firebaseReferances.dart';
import 'package:passenger/functions/validators.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  static const String idScreen = "login";

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  //text editing controllers

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
              "Login as a Passenger",
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
                  TextField(
                    controller: passwordController,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.yellow, fontSize: 18),
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                        labelStyle:
                            TextStyle(fontSize: 14.0, color: Colors.white),
                        hintStyle:
                            TextStyle(fontSize: 10.0, color: Colors.grey)),
                  ),
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
                      } else if (passwordController.text.isEmpty) {
                        redMessenger(context, "Enter Password to login!");
                      } else {
                        String username = usernameController.text.trim();
                        String password = passwordController.text.trim();
                        //login function
                        log(username.toString());
                        log(password.toString());
                        loginPassenger(context, username, password);
                      }
                    },
                    child: Container(
                      height: 50,
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "Brand Bolt"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, registrationScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Do not have an Account? Register Here.",
                  style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 14.0,
                      fontFamily: "Brand Bold"),
                  textAlign: TextAlign.center,
                )),
            TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, resetpassword.idScreen, (route) => false);
                },
                child: Text(
                  "forgot password ?",
                  style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 14.0,
                      fontFamily: "Brand Bold"),
                  textAlign: TextAlign.center,
                ))
          ],
        ),
      ),
    );
  }

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginPassenger(
      BuildContext context, String username, String password) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return progressBar("Loging In Please wait");
        });

    try {
      final User? firebaseuser = (await _firebaseAuth
              .signInWithEmailAndPassword(email: username, password: password))
          .user;
      log("here reached");

      if (firebaseuser != null) {
        passengerRef.child(firebaseuser.uid).once().then((value) => {
              if (value.snapshot.value != null)
                {
                  Navigator.pop(context),
                  assistanceMethods.getCurrentOnlineUserInformation,
                  greenMessenger(context, "Welcome..!"),
                  Navigator.pushNamedAndRemoveUntil(
                      context, mainScreen.idScreen, (route) => false)
                }
              else
                {
                  _firebaseAuth.signOut(),
                  // add code to delete the auth deatils later
                  Navigator.pop(context),
                  redMessenger(context, "no data exists in database")
                }
            });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text("No user found for that email..")),
        );
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.deepOrange,
              content: Text("Wrong password provided for that user.")),
        );
      }
    }
  }
}
