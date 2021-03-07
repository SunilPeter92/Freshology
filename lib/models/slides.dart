// To parse this JSON data, do
//
//     final slide = slideFromJson(jsonString);

import 'dart:convert';

import 'package:freshology/models/media.dart';

Slide slideFromJson(String str) => Slide.fromJson(json.decode(str));

String slideToJson(Slide data) => json.encode(data.toJson());

class Slide {
  Slide({
    this.id,
    this.order,
    this.text,
    this.button,
    this.textPosition,
    this.textColor,
    this.buttonColor,
    this.backgroundColor,
    this.indicatorColor,
    this.imageFit,
    this.foodId,
    this.restaurantId,
    this.enabled,
    this.createdAt,
    this.updatedAt,
    this.customFields,
    this.hasMedia,
    this.media,
  });

  int id;
  int order;
  String text;
  String button;
  String textPosition;
  dynamic textColor;
  dynamic buttonColor;
  dynamic backgroundColor;
  String indicatorColor;
  String imageFit;
  int foodId;
  int restaurantId;
  bool enabled;
  String createdAt;
  String updatedAt;
  List<dynamic> customFields;
  bool hasMedia;
  List<Media> media;

  factory Slide.fromJson(Map<String, dynamic> json) => Slide(
        id: json["id"] == null ? null : json["id"],
        order: json["order"] == null ? null : json["order"],
        text: json["text"] == null ? null : json["text"],
        button: json["button"] == null ? null : json["button"],
        textPosition:
            json["text_position"] == null ? null : json["text_position"],
        textColor: json["text_color"],
        buttonColor: json["button_color"],
        backgroundColor: json["background_color"],
        indicatorColor:
            json["indicator_color"] == null ? null : json["indicator_color"],
        imageFit: json["image_fit"] == null ? null : json["image_fit"],
        foodId: json["food_id"] == null ? null : json["food_id"],
        restaurantId:
            json["restaurant_id"] == null ? null : json["restaurant_id"],
        enabled: json["enabled"] == null ? null : json["enabled"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
        customFields: json["custom_fields"] == null
            ? null
            : List<dynamic>.from(json["custom_fields"].map((x) => x)),
        hasMedia: json["has_media"] == null ? null : json["has_media"],
        media: json["media"] == null
            ? null
            : List<Media>.from(json["media"].map((x) => Media.fromJSON(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "order": order == null ? null : order,
        "text": text == null ? null : text,
        "button": button == null ? null : button,
        "text_position": textPosition == null ? null : textPosition,
        "text_color": textColor,
        "button_color": buttonColor,
        "background_color": backgroundColor,
        "indicator_color": indicatorColor == null ? null : indicatorColor,
        "image_fit": imageFit == null ? null : imageFit,
        "food_id": foodId == null ? null : foodId,
        "restaurant_id": restaurantId == null ? null : restaurantId,
        "enabled": enabled == null ? null : enabled,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
        "custom_fields": customFields == null
            ? null
            : List<dynamic>.from(customFields.map((x) => x)),
        "has_media": hasMedia == null ? null : hasMedia,
      };
}
