// To parse this JSON data, do
//
//     final requestModel = requestModelFromMap(jsonString);

import 'dart:convert';

RequestModel requestModelFromMap(String str) =>
    RequestModel.fromMap(json.decode(str));

String requestModelToMap(RequestModel data) => json.encode(data.toMap());

class RequestModel {
  RequestModel({
    this.id,
    this.accepted,
    this.receiver,
    this.sender,
    this.timestamp,
  });

  final String? id;
  final bool? accepted;
  final String? receiver;
  final String? sender;
  final int? timestamp;

  RequestModel copyWith({
    String? id,
    bool? accepted,
    String? receiver,
    String? sender,
    int? timestamp,
  }) =>
      RequestModel(
        id: id ?? this.id,
        accepted: accepted ?? this.accepted,
        receiver: receiver ?? this.receiver,
        sender: sender ?? this.sender,
        timestamp: timestamp ?? this.timestamp,
      );

  factory RequestModel.fromMap(Map<String, dynamic> json) => RequestModel(
        id: json["id"],
        accepted: json["accepted"],
        receiver: json["receiver"],
        sender: json["sender"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "accepted": accepted,
        "receiver": receiver,
        "sender": sender,
        "timestamp": timestamp,
      };
}
