import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:passenger/AllScreens/loginScreen.dart';
import 'package:passenger/AllScreens/mainScreen.dart';
import 'package:passenger/AllScreens/registrationScreen.dart';
import 'package:passenger/AllScreens/resetpassword.dart';
import 'package:passenger/DataHandler/appData.dart';
import 'package:passenger/functions/permissions.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    listenforpermissions();
    super.initState();
  }

  // This widget is the root of passenger application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => appData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eyy-AUTO Passenger',
        theme: ThemeData(primarySwatch: Colors.yellow),
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? loginScreen.idScreen
            : mainScreen.idScreen,
        routes: {
          registrationScreen.idScreen: (context) => registrationScreen(),
          loginScreen.idScreen: (context) => loginScreen(),
          mainScreen.idScreen: (context) => mainScreen(),
          resetpassword.idScreen: ((context) => resetpassword())
        },
      ),
    );
  }
}
