// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

UserGeneralModel userGeneralModelFromJson(String str) =>
    UserGeneralModel.fromJson(json.decode(str));

String userGeneralModelToJson(UserGeneralModel data) =>
    json.encode(data.toJson());

class UserGeneralModel {
  UserGeneralModel(
      {required this.username,
      required this.password,
      required this.email,
      required this.cellPhone});

  String username;
  String password;
  String email;
  String cellPhone;

  factory UserGeneralModel.fromJson(Map<String, dynamic> json) =>
      UserGeneralModel(
        username: json["username"],
        password: json["password"],
        email: json["email"],
        cellPhone: json["cellPhone"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "email": email,
        "cellPhone": cellPhone
      };
}
