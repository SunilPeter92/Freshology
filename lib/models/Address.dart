// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);

import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  Address({
    this.id,
    this.userId,
    this.area,
    this.areaId,
    this.city,
    this.cityId,
    this.houseNo,
    this.pinecode,
    this.state,
    this.stateId,
    this.country,
    this.countryId,
    this.deliveryFee,
  });

  Address.empty({
    this.id = null,
    this.userId = '',
    this.area = '',
    this.areaId = '',
    this.city = '',
    this.cityId = '',
    this.houseNo = '',
    this.pinecode = '',
    this.state = '',
    this.stateId = '',
    this.country = '',
    this.countryId = '',
    this.deliveryFee = '',
  });

  String id;
  String userId;
  String area;
  String areaId;
  String city;
  String cityId;
  String houseNo;
  String pinecode;
  String state;
  String stateId;
  String country;
  String countryId;
  String deliveryFee;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"] == null ? null : json["id"].toString(),
        userId: json["user_id"] == null ? null : json["user_id"],
        area: json["area"] == null ? null : json["area"],
        areaId: json["area_id"] == null ? null : json["area_id"],
        city: json["city"] == null ? null : json["city"],
        cityId: json["city_id"] == null ? null : json["city_id"],
        houseNo: json["house_no"] == null ? null : json["house_no"],
        pinecode: json["pinecode"] == null ? null : json["pinecode"],
        state: json["state"] == null ? null : json["state"],
        stateId: json["state_id"] == null ? null : json["state_id"],
        country: json["country"] == null ? null : json["country"],
        countryId: json["country_id"] == null ? null : json["country_id"],
        deliveryFee: json['delivery_fee'] == null ? null : json['delivery_fee'],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "area": area == null ? null : area,
        "area_id": areaId == null ? null : areaId,
        "city": city == null ? null : city,
        "city_id": cityId == null ? null : cityId,
        "house_no": houseNo == null ? null : houseNo,
        "pinecode": pinecode == null ? null : pinecode,
        "state": state == null ? null : state,
        "state_id": stateId == null ? null : stateId,
        "country": country == null ? null : country,
        "country_id": countryId == null ? null : countryId,
        "delivery_fee": countryId == null ? null : countryId,
      };
}
