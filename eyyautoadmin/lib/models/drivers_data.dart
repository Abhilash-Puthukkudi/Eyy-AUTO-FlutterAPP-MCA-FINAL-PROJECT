// To parse this JSON data, do
//
//     final driversData = driversDataFromJson(jsonString);

import 'dart:convert';

DriversData driversDataFromJson(String str) =>
    DriversData.fromJson(json.decode(str));

String driversDataToJson(DriversData data) => json.encode(data.toJson());

class DriversData {
  DriversData(
      {this.autoDetails,
      this.email,
      this.name,
      this.phone,
      this.status,
      this.id,
      this.password});

  AutoDetails? autoDetails;
  String? email;
  String? name;
  String? phone;
  String? status;
  String? id;
  String? password;

  factory DriversData.fromJson(Map<String, dynamic> json) => DriversData(
      autoDetails: AutoDetails.fromJson(json["auto_Details"]),
      email: json["email"],
      name: json["name"],
      phone: json["phone"],
      status: json["status"],
      id: json["id"],
      password: json["password"]);

  Map<String, dynamic> toJson() => {
        "auto_Details": autoDetails!.toJson(),
        "email": email,
        "name": name,
        "phone": phone,
        "status": status,
        "id": id,
        "password": password
      };
}

class AutoDetails {
  AutoDetails({
    this.autoNumber,
    this.licenceNumber,
  });

  String? autoNumber;
  String? licenceNumber;

  factory AutoDetails.fromJson(Map<String, dynamic> json) => AutoDetails(
        autoNumber: json["auto_number"],
        licenceNumber: json["licence_number"],
      );

  Map<String, dynamic> toJson() => {
        "auto_number": autoNumber,
        "licence_number": licenceNumber,
      };
}
