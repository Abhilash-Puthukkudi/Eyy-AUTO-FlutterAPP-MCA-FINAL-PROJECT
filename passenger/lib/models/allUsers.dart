import 'package:firebase_database/firebase_database.dart';

class Users {
  String? id;
  String? email;
  String? name;
  String? phone;
  Users({this.id, this.email, this.name, this.phone});

  Users.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key;
    //getting the data and maping to data varible then accessing using keys
    var data = dataSnapshot.value as Map?;

    email = data!["email"];
    name = data["name"];
    phone = data["phone"];
  }
}
