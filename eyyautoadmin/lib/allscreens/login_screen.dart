import 'dart:developer';

import 'package:eyyautoadmin/allscreens/dashbord.dart';
import 'package:eyyautoadmin/allscreens/reset_screen.dart';
import 'package:eyyautoadmin/functions/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/progressWidget.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  static const String idScreen = "loginscreen";

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(223, 34, 34, 34),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40.0),
            const Image(
              image: AssetImage("images/logo.png"),
              width: 390,
              height: 250,
              alignment: Alignment.center,
            ),
            const SizedBox(height: 10.0),
            const Text(
              "Welcome Admin",
              style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 28.0,
                  fontFamily: "Brand Bold"),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const SizedBox(
                    width: double.infinity,
                  ),
                  const SizedBox(height: 1.0),
                  Container(
                    width: 500,
                    child: TextField(
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
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    width: 500,
                    child: TextField(
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
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    width: 150,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      side: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 8, 7, 7))))),
                      onPressed: () {
                        if (usernameController.text.isEmpty) {
                          redMessenger(context, "Enter Username  to login!");
                        } else if (passwordController.text.isEmpty) {
                          redMessenger(context, "Enter Password to login!");
                        } else {
                          String username = usernameController.text.trim();
                          String password = passwordController.text.trim();
                          // //login function
                          // // log(username.toString());
                          // // log(password.toString());
                          // registerUser(context, username, password);
                          loginPassenger(context, username, password);
                        }

                        // DatabaseReference testRef =
                        //     FirebaseDatabase.instance.ref().child("test");
                        // testRef.set({"hai": "hello"});

                        // yellowMessenger(
                        //     context, "this feature will avilable soon!!");
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
                  ),
                ],
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, ResetPasswordscreen.idScreen, (route) => false);
                },
                child: Text(
                  "forgot Password? ",
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

// reg

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // void registerUser(
  //   BuildContext context,
  //   String email,
  //   String password,
  // ) async {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return progressBar("Registering.. please wait.");
  //       });

  //   try {
  //     final User? firebaseUser = (await _firebaseAuth
  //             .createUserWithEmailAndPassword(email: email, password: password))
  //         .user;

  //     if (firebaseUser != null) {
  //       // user created

  //       Map adminDataMap = {"email": email, "role": "admin"};

  //       adminRef.child(firebaseUser.uid).set(adminDataMap);
  //       Navigator.pop(context);
  //       yellowMessenger(context,
  //           "Congratulations your account has been created sucessfully. Please login to continue.");
  //       Navigator.pushNamedAndRemoveUntil(
  //           context, loginScreen.idScreen, (route) => false);
  //     } else {
  //       Navigator.pop(context);
  //       redMessenger(context, "New passenger account not created");
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       Navigator.pop(context);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             backgroundColor: Colors.red,
  //             content: Text("The password provided is too weak.")),
  //       );
  //       print('The password provided is too weak.');
  //     } else if (e.code == 'email-already-in-use') {
  //       Navigator.pop(context);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             backgroundColor: Colors.red,
  //             content: Text("The account already exists for that email.")),
  //       );
  //     } else {
  //       // log(e.toString());
  //     }
  //   } catch (e) {
  //     // log(e.toString());
  //   }
  // }

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
      // log("here reached");
      Map? adminMap = {};
      if (firebaseuser != null) {
        try {
          adminRef.child(firebaseuser.uid).once().then((value) => {
                if (value.snapshot.value != null)
                  {
                    Navigator.pop(context),
                    adminMap = value.snapshot.value as Map,
                    if (adminMap!.containsKey('role'))
                      {
                        if (adminMap!['role'] == 'admin')
                          {
                            yellowMessenger(context, "Welcome..!"),
                            Navigator.pushNamedAndRemoveUntil(
                                context, DashBord.idScreen, (route) => false)
                          },
                      }
                    else
                      {redMessenger(context, "You dont have admin previlages!")}
                    // Navigator.pushNamedAndRemoveUntil(
                    //     context, mainScreen.idScreen, (route) => false)
                  }
                else
                  {
                    _firebaseAuth.signOut(),
                    // add code to delete the auth deatils later
                    Navigator.pop(context),
                    redMessenger(context, "You dont have admin previlages!")
                  }
              });
        } catch (e) {

          
          redMessenger(context, "invalid admin");
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: const Text("No user found for that email..")),
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
