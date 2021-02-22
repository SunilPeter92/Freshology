import 'package:flutter/cupertino.dart';

class OffersModel {
  String name;
  String price;
  String weight;
  String image;
  String offers;
  double cGST;
  double sGST;
  double iGST;
  String sKU;
  String hSN;
  String description;
  bool clickable;
  String category;

  OffersModel({
    @required this.name,
    this.description,
    this.category,
    this.clickable,
    @required this.image,
    @required this.weight,
    @required this.price,
    @required this.offers,
    @required this.cGST,
    @required this.hSN,
    @required this.iGST,
    @required this.sGST,
    @required this.sKU,
  });
}
