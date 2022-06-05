import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../functions/validators.dart';

class ResetPasswordscreen extends StatefulWidget {
  const ResetPasswordscreen({Key? key}) : super(key: key);

  static const String idScreen = "resetscreen";

  @override
  State<ResetPasswordscreen> createState() => _ResetPasswordscreenState();
}

class _ResetPasswordscreenState extends State<ResetPasswordscreen> {
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
              "Enter Registerd Email address for reseting password",
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
                    width: 600,
                    child: const TextField(
                      // controller: usernameController,
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
                  const SizedBox(height: 20.0),
                  Container(
                    width: 200,
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
                        // if (usernameController.text.isEmpty) {
                        //   redMessenger(context, "Enter Username  to login!");
                        // } else if (passwordController.text.isEmpty) {
                        //   redMessenger(context, "Enter Password to login!");
                        // } else {
                        // String username = usernameController.text.trim();
                        // String password = passwordController.text.trim();
                        //login function
                        // log(username.toString());
                        // log(password.toString());
                        // loginPassenger(context, username, password);
                        // }
                        yellowMessenger(
                            context, "this feature will avilable soon!!");
                      },
                      child: Container(
                        height: 50,
                        child: Center(
                          child: const Text(
                            "send reset email",
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
          ],
        ),
      ),
    );
  }
}
