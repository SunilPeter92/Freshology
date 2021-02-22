// To parse this JSON data, do
//
//     final adBanner = adBannerFromJson(jsonString);

import 'dart:convert';

AdBanner adBannerFromJson(String str) => AdBanner.fromJson(json.decode(str));

String adBannerToJson(AdBanner data) => json.encode(data.toJson());

class AdBanner {
  AdBanner({
    this.type,
    this.clickable,
    this.bData,
  });

  String type;
  String clickable;
  String bData;

  factory AdBanner.fromJson(Map<String, dynamic> json) => AdBanner(
        type: json["type"],
        clickable: json["clickable"],
        bData: json["b_data"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "clickable": clickable,
        "b_data": bData,
      };
}
