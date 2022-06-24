import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passenger/AllScreens/loginScreen.dart';
import 'package:passenger/allwidgets/progressWidget.dart';
import 'package:passenger/functions/firebaseReferances.dart';
import 'package:passenger/functions/validators.dart';

class registrationScreen extends StatefulWidget {
  const registrationScreen({Key? key}) : super(key: key);

//--- page routes start---
  static const String idScreen = "register";
//--- page routes end ---

  @override
  State<registrationScreen> createState() => _registrationScreenState();
}

class _registrationScreenState extends State<registrationScreen> {
  //---- Text editing controllers start-----

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

//---- Text editing controllers stop-----

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
              "Register as a Passenger",
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
                    controller: nameController,
                    style: TextStyle(color: Colors.yellow, fontSize: 18),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Name",
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
                    controller: phoneController,
                    style: TextStyle(color: Colors.yellow, fontSize: 18),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Phone number",
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
                    controller: emailController,
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
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Color.fromARGB(255, 8, 7, 7))))),
                    onPressed: () {
                      if (nameController.text.length < 4) {
                        redMessenger(
                            context, "Name must be atleast 3 charcters!");
                      } else if (nameController.text.length > 20) {
                        redMessenger(
                            context, "Maximum name characters are 20!");
                      } else if (phoneController.text.length != 10) {
                        redMessenger(context, "Enter a valid Phonenumber!");
                      } else if (!RegExp(r'\S+@\S+\.\S+')
                          .hasMatch(emailController.text)) {
                        redMessenger(
                            context, "Please enter a valid email address");
                      } else if (passwordController.text.length < 5) {
                        redMessenger(context, "Enter a Strong password");
                      } else {
                        String email = emailController.text.trim();
                        String password = passwordController.text.trim();
                        String phonenumber = phoneController.text.trim();
                        String name = nameController.text.trim();

                        registerUser(
                            context, email, password, phonenumber, name);
                      }
                    },
                    child: Container(
                      height: 50,
                      child: Center(
                        child: Text(
                          "Register",
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
                      context, loginScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Already have an Account? Login Here.",
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

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerUser(BuildContext context, String email, String password,
      String phonenumber, String name) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return progressBar("Registering.. please wait.");
        });

    try {
      final User? firebaseUser = (await _firebaseAuth
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;

      if (firebaseUser != null) {
        // user created

        Map PassengerDataMap = {
          "id": firebaseUser.uid.toString(),
          "name": name,
          "phone": phonenumber,
          "email": email
        };

        passengerRef.child(firebaseUser.uid).set(PassengerDataMap);
        Navigator.pop(context);
        greenMessenger(context,
            "Congratulations your account has been created sucessfully. Please login to continue.");
        Navigator.pushNamedAndRemoveUntil(
            context, loginScreen.idScreen, (route) => false);
      } else {
        Navigator.pop(context);
        redMessenger(context, "New passenger account not created");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text("The password provided is too weak.")),
        );
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text("The account already exists for that email.")),
        );
      } else {
        log(e.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
