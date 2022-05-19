import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:passenger/AllScreens/loginScreen.dart';
import 'package:passenger/AllScreens/mainScreen.dart';
import 'package:passenger/AllScreens/registrationScreen.dart';
import 'package:passenger/DataHandler/appData.dart';
import 'package:provider/provider.dart';
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
    return ChangeNotifierProvider(
      create: (context) => appData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.yellow),
        initialRoute: mainScreen.idScreen,
        routes: {
          registrationScreen.idScreen: (context) => registrationScreen(),
          loginScreen.idScreen: (context) => loginScreen(),
          mainScreen.idScreen: (context) => mainScreen()
        },
      ),
    );
  }
}
