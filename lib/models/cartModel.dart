import 'package:flutter/cupertino.dart';

class CartModel {
  String productName;
  String productPrice;
  String productWeight;
  int productQuantity;
  String productImageUrl;
  int productTotalPrice;
  double cGST;
  double sGST;
  double iGST;
  String sKU;
  String hSN;

  CartModel({
    @required this.productImageUrl,
    @required this.productName,
    @required this.productPrice,
    @required this.productTotalPrice,
    @required this.productQuantity,
    @required this.productWeight,
    @required this.cGST,
    @required this.hSN,
    @required this.iGST,
    @required this.sGST,
    @required this.sKU,
  });
}
