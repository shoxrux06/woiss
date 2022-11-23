// To parse this JSON data, do
//
//     final agentModel = agentModelFromJson(jsonString);

import 'dart:convert';

List<AgentModel> agentModelFromJson(String str) => List<AgentModel>.from(json.decode(str).map((x) => AgentModel.fromJson(x)));

String agentModelToJson(List<AgentModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AgentModel {
  AgentModel({
   required this.id,
   required this.username,
   required this.email,
  });

  int id;
  String username;
  String email;

  factory AgentModel.fromJson(Map<String, dynamic> json) => AgentModel(
    id: json["id"],
    username: json["username"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
  };
}
