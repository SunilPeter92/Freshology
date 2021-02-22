import 'dart:convert';

SubCategory subCategoryFromJson(String str) =>
    SubCategory.fromJson(json.decode(str));

String subCategoryToJson(SubCategory data) => json.encode(data.toJson());

class SubCategory {
  SubCategory({
    this.id,
    this.cateId,
    this.name,
    this.image,
    this.status,
  });

  int id;
  String cateId;
  String name;
  String image;
  int status;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json["id"],
        cateId: json["cate_id"],
        name: json["name"],
        image: json["image"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cate_id": cateId,
        "name": name,
        "image": image,
        "status": status,
      };
}
