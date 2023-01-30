// To parse this JSON data, do
//
//     final contactModel = contactModelFromJson(jsonString);

import 'dart:convert';

ProfileModel contactModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String contactModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    required this.username,
    required this.email,
    required this.name,
    required this.lastName,
    required this.fechaVerificacion,
    required this.contacts,
    required this.cellPhone,
    required this.firstSession,
    required this.colour,
  });

  String username;
  String email;
  String name;
  String lastName;
  DateTime fechaVerificacion;
  List<Contact> contacts;
  String cellPhone;
  bool firstSession;
  String colour;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        username: json["username"],
        email: json["email"],
        name: json["name"],
        lastName: json["lastName"],
        fechaVerificacion: DateTime.parse(json["fechaVerificacion"]),
        contacts: List<Contact>.from(
            json["contacts"].map((x) => Contact.fromJson(x))),
        cellPhone: json["cellPhone"],
        firstSession: json["firstSession"],
        colour: json["colour"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "name": name,
        "lastName": lastName,
        "fechaVerificacion": fechaVerificacion.toIso8601String(),
        "contacts": List<dynamic>.from(contacts.map((x) => x.toJson())),
        "cellPhone": cellPhone,
        "firstSession": firstSession,
        "colour": colour,
      };
}

class Contact {
  Contact({
    required this.name,
    required this.lastName,
    required this.email,
    required this.cellPhone,
  });

  String name;
  String lastName;
  String email;
  String cellPhone;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        name: json["name"],
        lastName: json["lastName"],
        email: json["email"],
        cellPhone: json["cellPhone"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "lastName": lastName,
        "email": email,
        "cellPhone": cellPhone,
      };
}
