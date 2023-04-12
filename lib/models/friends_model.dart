// To parse this JSON data, do
//
//     final friendModel = friendModelFromMap(jsonString);

import 'dart:convert';

FriendModel friendModelFromMap(String str) =>
    FriendModel.fromMap(json.decode(str));

String friendModelToMap(FriendModel data) => json.encode(data.toMap());

class FriendModel {
  FriendModel({
    this.email,
    this.friend,
    this.isBlocked,
    this.timestamp,
  });

  final String? email;
  final String? friend;
  final bool? isBlocked;
  final int? timestamp;

  FriendModel copyWith({
    String? email,
    String? friend,
    bool? isBlocked,
    int? timestamp,
  }) =>
      FriendModel(
        email: email ?? this.email,
        friend: friend ?? this.friend,
        isBlocked: isBlocked ?? this.isBlocked,
        timestamp: timestamp ?? this.timestamp,
      );

  factory FriendModel.fromMap(Map<String, dynamic> json) => FriendModel(
        email: json["email"],
        friend: json["friend"],
        isBlocked: json["isBlocked"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "friend": friend,
        "isBlocked": isBlocked,
        "timestamp": timestamp,
      };
}
