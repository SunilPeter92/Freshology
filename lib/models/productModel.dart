import 'package:flutter/cupertino.dart';

class ProductModel {
  String name;
  String price;
  String weight;
  String imageUrl;
  int quantity;
  double cGST;
  double sGST;
  double iGST;
  String sKU;
  String hSN;
  String description;

  ProductModel({
    @required this.name,
    this.description,
    @required this.imageUrl,
    @required this.weight,
    @required this.price,
    @required this.quantity,
    @required this.cGST,
    @required this.hSN,
    @required this.iGST,
    @required this.sGST,
    @required this.sKU,
  });
}
