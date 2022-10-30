// To parse this JSON data, do
//
//     final contactModel = contactModelFromJson(jsonString);

import 'dart:convert';

ContactModel contactModelFromJson(String str) =>
    ContactModel.fromJson(json.decode(str));

String contactModelToJson(ContactModel data) => json.encode(data.toJson());

class ContactModel {
  ContactModel({
    required this.name,
    required this.lastName,
    required this.email,
    required this.cellPhone,
  });

  String name;
  String lastName;
  String email;
  String cellPhone;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
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
