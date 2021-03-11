// To parse this JSON data, do
//
//     final userWallet = userWalletFromJson(jsonString);

import 'dart:convert';

import 'package:freshology/models/userModel.dart';

UserWallet userWalletFromJson(String str) =>
    UserWallet.fromJson(json.decode(str));

String userWalletToJson(UserWallet data) => json.encode(data.toJson());

class UserWallet {
  UserWallet({
    this.id,
    this.userId,
    this.amount,
    this.status,
  });

  int id;
  String userId;
  String amount;
  int status;



  factory UserWallet.fromJson(Map<String, dynamic> json) => UserWallet(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        amount: json["amount"] == null ? null : json["amount"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "amount": amount == null ? null : amount,
        "status": status == null ? null : status,
      };
}
