import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderModel {
  String orderID;
  String orderAmount;
  Timestamp orderTime;
  bool orderIsComplete;
  String orderStatus;
  String orderPaymentMethod;
  Timestamp orderDeliveryDate;
  String orderDeliveryTime;
  List<OrderProductModel> orderItems;
  int discount;
  String invoiceId;
  bool deliveryCharge;
  String link;

  OrderModel({
    this.orderItems,
    this.link,
    @required this.orderStatus,
    @required this.orderTime,
    @required this.orderAmount,
    @required this.orderID,
    @required this.orderDeliveryDate,
    @required this.orderDeliveryTime,
    @required this.orderIsComplete,
    @required this.orderPaymentMethod,
    @required this.discount,
    @required this.deliveryCharge,
    @required this.invoiceId,
  });
}

class OrderProductModel {
  String name;
  String price;
  String weight;
  int quantity;
  double cGST;
  double sGST;
  double iGST;
  String sKU;
  String hSN;

  OrderProductModel({
    @required this.name,
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
