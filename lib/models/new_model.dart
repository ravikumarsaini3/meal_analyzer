// To parse this JSON data, do
//
//     final newModel = newModelFromJson(jsonString);

import 'dart:convert';

List<NewModel> newModelFromJson(String str) => List<NewModel>.from(json.decode(str).map((x) => NewModel.fromJson(x)));

String newModelToJson(List<NewModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewModel {
  int userId;
  int id;
  String title;
  bool completed;

  NewModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory NewModel.fromJson(Map<String, dynamic> json) => NewModel(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    completed: json["completed"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
    "completed": completed,
  };
}
