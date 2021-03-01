// To parse this JSON data, do
//
//     final subCategory = subCategoryFromJson(jsonString);

import 'dart:convert';

SubCategory subCategoryFromJson(String str) =>
    SubCategory.fromJson(json.decode(str));

String subCategoryToJson(SubCategory data) => json.encode(data.toJson());

class SubCategory {
  SubCategory({
    this.data,
    this.smedia,
  });

  Data data;
  String smedia;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        data: Data.fromJson(json["data"]),
        smedia: json["smedia"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "media": smedia,
      };
}

class Data {
  Data({
    this.id,
    this.pId,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String pId;
  String name;
  String description;
  String createdAt;
  String updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        pId: json["p_id"],
        name: json["name"],
        description: json["description"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "p_id": pId,
        "name": name,
        "description": description,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
