// To parse this JSON data, do
//
//     final mainCategory = mainCategoryFromJson(jsonString);

import 'dart:convert';

MainCategory mainCategoryFromJson(String str) =>
    MainCategory.fromJson(json.decode(str));

String mainCategoryToJson(MainCategory data) => json.encode(data.toJson());

class MainCategory {
  MainCategory({
    this.id,
    this.name,
    this.image,
    this.status,
  });

  int id;
  String name;
  String image;
  int status;

  factory MainCategory.fromJson(Map<String, dynamic> json) => MainCategory(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "status": status,
      };
}
