import 'package:eyyautoadmin/allscreens/dashbord.dart';
import 'package:eyyautoadmin/allscreens/login_screen.dart';
import 'package:eyyautoadmin/allscreens/reset_screen.dart';
import 'package:eyyautoadmin/functions/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        //  // Navigator.pushNamedAndRemoveUntil(context,
        //     DashBord().idScreen, (route) => false) // Navigator.pushNamedAndRemoveUntil(context,
        //     DashBord().idScreen, (route) => false) // Navigator.pushNamedAndRemoveUntil(context,
        //     DashBord().idScreen, (route) => false)r.pushNamedAndRemoveUntil(context,
        //     DashBord().idScreen, (route) => false)
        primarySwatch: Colors.yellow,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? loginScreen.idScreen
          : DashBord.idScreen,
      routes: {
        loginScreen.idScreen: (context) => const loginScreen(),
        ResetPasswordscreen.idScreen: (context) => const ResetPasswordscreen(),
        DashBord.idScreen: (context) => const DashBord()
      },
    );
  }
}
