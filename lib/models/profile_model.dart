// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    required this.username,
    required this.email,
    required this.name,
    required this.lastName,
    required this.fechaVerificacion,
    required this.contacts,
    required this.cellPhone,
  });

  String username;
  String email;
  String name;
  String lastName;
  DateTime fechaVerificacion;
  List<dynamic> contacts;
  String cellPhone;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        username: json["username"],
        email: json["email"],
        name: json["name"],
        lastName: json["lastName"],
        fechaVerificacion: DateTime.parse(json["fechaVerificacion"]),
        contacts: List<dynamic>.from(json["contacts"].map((x) => x)),
        cellPhone: json["cellPhone"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "name": name,
        "lastName": lastName,
        "fechaVerificacion": fechaVerificacion.toIso8601String(),
        "contacts": List<dynamic>.from(contacts.map((x) => x)),
        "cellPhone": cellPhone,
      };
}
