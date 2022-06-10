import 'package:eyyautoadmin/allscreens/dashbord_home_screen.dart';
import 'package:eyyautoadmin/allscreens/login_screen.dart';
import 'package:eyyautoadmin/allscreens/manage_drivers_screen.dart';
import 'package:eyyautoadmin/allscreens/view_drivers_screen.dart';
import 'package:eyyautoadmin/allscreens/view_passengers_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import '../functions/validators.dart';

class DashBord extends StatefulWidget {
  const DashBord({Key? key}) : super(key: key);

  static const String idScreen = "dashbord";

  @override
  State<DashBord> createState() => _DashBordState();
}

class _DashBordState extends State<DashBord> {
  Widget _selectedScreen = dashboardHome();

  currentScreen(item) {
    switch (item.route) {
      case dashboardHome.idScreen:
        setState(() {
          _selectedScreen = const dashboardHome();
        });
        break;
      case viewPassengers.idScreen:
        setState(() {
          _selectedScreen = const viewPassengers();
        });
        break;
      case viewDrivers.idScreen:
        setState(() {
          _selectedScreen = const viewDrivers();
        });
        break;
      case manageDriver.idScreen:
        setState(() {
          _selectedScreen = const manageDriver();
        });
        break;
      case loginScreen.idScreen:
        setState(() {
          FirebaseAuth.instance.signOut();
          Navigator.pushNamedAndRemoveUntil(
              context, loginScreen.idScreen, ((route) => false));
          yellowMessenger(context, "Logout Sucessfull !");
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Color.fromARGB(223, 34, 34, 34),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Eyy-Auto Booking ',
          style: TextStyle(fontFamily: "Brand Bold"),
        ),
      ),
      sideBar: SideBar(
        backgroundColor: Color.fromARGB(223, 34, 34, 34),
        width: 250,
        borderColor: Colors.black,
        iconColor: Colors.yellow,
        activeIconColor: Colors.black,
        activeBackgroundColor: Colors.yellow,
        textStyle: TextStyle(
            color: Colors.yellow, fontSize: 15, fontFamily: "Brand Bold"),
        activeTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: "Brand Bold",
            fontSize: 18,
            fontWeight: FontWeight.bold),
        //  TextStyle = const
        items: const [
          AdminMenuItem(
              title: 'Home', route: dashboardHome.idScreen, icon: Icons.home),
          AdminMenuItem(
              title: 'View passengers',
              route: viewPassengers.idScreen,
              icon: Icons.people),
          AdminMenuItem(
              title: 'View Drivers',
              route: viewDrivers.idScreen,
              icon: Icons.emoji_people),
          AdminMenuItem(
              title: 'Manage Drivers',
              route: manageDriver.idScreen,
              icon: Icons.settings),
          AdminMenuItem(
            title: 'Logout',
            route: loginScreen.idScreen,
            icon: Icons.logout,
          ),
        ],
        selectedRoute: DashBord.idScreen,
        onSelected: (item) {
          currentScreen(item);
        },
        header: Container(
          height: 100,
          width: double.infinity,
          color: const Color(0xff444444),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Image.asset(
                    'images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'ADMIN',
                    style: TextStyle(
                      fontFamily: "Brand Bold",
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(child: _selectedScreen),
    );
  }
}
