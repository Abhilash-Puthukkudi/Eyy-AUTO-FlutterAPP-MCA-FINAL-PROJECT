import 'package:eyyautoadmin/allscreens/reset_screen.dart';
import 'package:eyyautoadmin/functions/validators.dart';
import 'package:flutter/material.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  static const String idScreen = "loginscreen";

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
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
                  Container(
                    width: 500,
                    child: const TextField(
                      // controller: passwordController,
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
}
