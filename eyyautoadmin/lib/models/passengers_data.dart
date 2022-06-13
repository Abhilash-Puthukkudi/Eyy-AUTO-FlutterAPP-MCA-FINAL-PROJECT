// To parse this JSON data, do
//
//     final passengersData = passengersDataFromJson(jsonString);

import 'dart:convert';

PassengersData passengersDataFromJson(String str) =>
    PassengersData.fromJson(json.decode(str));

String passengersDataToJson(PassengersData data) => json.encode(data.toJson());

class PassengersData {
  PassengersData({
    this.email,
    this.name,
    this.phone,
  });

  String? email;
  String? name;
  String? phone;

  factory PassengersData.fromJson(Map<String, dynamic> json) => PassengersData(
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "phone": phone,
      };
}
