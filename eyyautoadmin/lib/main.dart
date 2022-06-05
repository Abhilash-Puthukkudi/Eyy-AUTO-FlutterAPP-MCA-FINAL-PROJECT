import 'package:eyyautoadmin/allscreens/login_screen.dart';
import 'package:eyyautoadmin/allscreens/reset_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      home: const loginScreen(),
      routes: {
        loginScreen.idScreen: (context) => loginScreen(),
        ResetPasswordscreen.idScreen: (context) => ResetPasswordscreen()
      },
    );
  }
}
