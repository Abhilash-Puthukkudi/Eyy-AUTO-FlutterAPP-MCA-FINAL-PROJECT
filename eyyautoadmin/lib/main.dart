import 'package:eyyautoadmin/allscreens/login_screen.dart';
import 'package:eyyautoadmin/allscreens/reset_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eyy-AutoBooking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const ResetPasswordscreen(),
      routes: {
        loginScreen.idScreen: (context) => loginScreen(),
        ResetPasswordscreen.idScreen: (context) => ResetPasswordscreen()
      },
    );
  }
}
