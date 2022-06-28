import 'package:driver/functions/configMaps.dart';
import 'package:driver/functions/firebaseReferances.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotficationService {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future initialize() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future getToken() async {
    String? token = await firebaseMessaging.getToken();
    print("This is token");
    print("token: ${token}");
    driverRef.child(currentFirebaseUSer!.uid).child("token").set(token);
    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");
  }
}
