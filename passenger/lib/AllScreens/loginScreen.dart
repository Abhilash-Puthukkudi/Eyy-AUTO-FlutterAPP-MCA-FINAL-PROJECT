import 'package:flutter/material.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(223, 24, 23, 23),
      body: Column(
        children: [
          SizedBox(height: 65.0),
          Image(
            image: AssetImage("images/icon.png"),
            width: 390,
            height: 250,
            alignment: Alignment.center,
          ),
          SizedBox(height: 1.0),
          Text(
            "Login as a Passenger",
            style: TextStyle(
                color: Colors.yellow, fontSize: 24.0, fontFamily: "Brand Bold"),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                SizedBox(height: 1.0),
                TextField(
                  style: TextStyle(color: Colors.yellow),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle:
                          TextStyle(fontSize: 14.0, color: Colors.white),
                      hintStyle: TextStyle(
                          fontSize: 10.0,
                          color: Color.fromARGB(255, 255, 255, 255))),
                ),
                SizedBox(height: 1.0),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle:
                          TextStyle(fontSize: 14.0, color: Colors.white),
                      hintStyle: TextStyle(fontSize: 10.0, color: Colors.grey)),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)))),
                  onPressed: () {},
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        "Login",
                        style:
                            TextStyle(fontSize: 18.0, fontFamily: "Brand Bolt"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
