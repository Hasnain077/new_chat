// To parse this JSON data, do
//
//     final userModel = userModelFromMap(jsonString);

import 'dart:convert';

UserModel userModelFromMap(String str) => UserModel.fromMap(json.decode(str));

String userModelToMap(UserModel data) => json.encode(data.toMap());

class UserModel {
  UserModel({
    this.email,
    this.mobile,
    this.name,
    this.uid,
  });

  final String? email;
  final String? mobile;
  final String? name;
  final String? uid;

  UserModel copyWith({
    String? email,
    String? mobile,
    String? name,
    String? uid,
  }) =>
      UserModel(
        email: email ?? this.email,
        mobile: mobile ?? this.mobile,
        name: name ?? this.name,
        uid: uid ?? this.uid,
      );

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        email: json["email"],
        mobile: json["mobile"],
        name: json["name"],
        uid: json["uid"],
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "mobile": mobile,
        "name": name,
        "uid": uid,
      };
}
