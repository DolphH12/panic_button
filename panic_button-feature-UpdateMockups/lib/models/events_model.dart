// To parse this JSON data, do
//
//     final listEventModel = listEventModelFromJson(jsonString);

import 'dart:convert';

ListEventModel listEventModelFromJson(String str) =>
    ListEventModel.fromJson(json.decode(str));

String listEventModelToJson(ListEventModel data) => json.encode(data.toJson());

class ListEventModel {
  ListEventModel({
    required this.name,
    required this.content,
    required this.contentType,
    required this.size,
    required this.suffix,
    required this.image,
    required this.color,
  });

  String name;
  Content content;
  String contentType;
  int size;
  String suffix;
  String image;
  String color;

  factory ListEventModel.fromJson(Map<String, dynamic> json) => ListEventModel(
        name: json["name"],
        content: Content.fromJson(json["content"]),
        contentType: json["contentType"],
        size: json["size"],
        suffix: json["suffix"],
        image: json["image"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "content": content.toJson(),
        "contentType": contentType,
        "size": size,
        "suffix": suffix,
        "image": image,
        "color": color,
      };
}

class Content {
  Content({
    required this.type,
    required this.data,
  });

  int type;
  String data;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        type: json["type"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "data": data,
      };
}
