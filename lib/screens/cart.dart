import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/controllers/cart_controller.dart';
import 'package:freshology/controllers/home_controller.dart';
import 'package:freshology/provider/cartProvider.dart';
import 'package:freshology/provider/productProvider.dart';
import 'package:freshology/provider/promoProvider.dart';
import 'package:freshology/provider/userProvider.dart';
import 'package:freshology/widget/EmptyCartWidget.dart';
import 'package:freshology/widget/startButton.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends StateMVC<Cart> {
  CartController _con;
  _CartState() : super(CartController()) {
    _con = controller;
  }
  int amount = 0;
  int discountGiven = 0;
  int deliveryCharge = 0;
  String promoText = '';
  FirebaseMessaging _fcm = FirebaseMessaging();
  Firestore _db = Firestore.instance;
  TextEditingController _promo = TextEditingController();

  StreamSubscription iosSubscription;

  Future<void> _saveDeviceToken() async {
    String uid = Provider.of<UserProvider>(context, listen: false).userDocID;
    String fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      var tokens = _db
          .collection('user')
          .document(uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }

  void applyPromo() {
    final promoProvider = Provider.of<PromoProvider>(context, listen: false);
    int dis = promoProvider.selectedCode.per;
    int max = promoProvider.selectedCode.maxDiscount;
    double discount = amount * (dis / 100);
    if (discount > max) {
      setState(() {
        discountGiven = max;
        promoText = 'You saved ₹ $discountGiven';
      });
    } else {
      setState(() {
        discountGiven = discount.floor();
        promoText = 'You saved ₹ $discountGiven';
      });
    }
  }

  @override
  void initState() {
    _con.listenForCarts();
    Future.delayed(Duration.zero, () {
      Provider.of<CartProvider>(context, listen: false).calculateTotalPrice();
      Provider.of<PromoProvider>(context, listen: false).getDeliveryCharge(
          Provider.of<UserProvider>(context, listen: false)
              .userDetail
              .areaName);
    });
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        _saveDeviceToken();
      });
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _saveDeviceToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final cartList = Provider.of<CartProvider>(context).cartProducts;
    final cartList = _con.carts;
    final cartProvider = Provider.of<CartProvider>(context);
    // final productProvider = Provider.of<ProductProvider>(context);
    final promoProvider = Provider.of<PromoProvider>(context);
    amount = cartProvider.totalValue;
    if (amount < 1000) {
      setState(() {
        deliveryCharge = promoProvider.deliveryCharge;
        cartProvider.deliveryCharge = true;
      });
    } else if (amount >= 1000) {
      setState(() {
        deliveryCharge = 0;
        cartProvider.deliveryCharge = false;
      });
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Cart',
          style: TextStyle(color: kDarkGreen),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: kDarkGreen),
      ),
      body: cartList.length == 0
          ? EmptyCartWidget()
          : ModalProgressHUD(
              inAsyncCall: promoProvider.isLoading,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 20,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          var product = cartList[index];
                          return Container(
                            margin: EdgeInsets.all(10),
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          product.product.name,
                                          style: kProductNameTextStyle,
                                        ),
                                        Text(
                                          product.product.weight.toString() +
                                              product.product.unit,
                                          style: kProductWeightTextStyle,
                                        ),
                                        Text(
                                          "₹ " +
                                              product.product.price
                                                  .toStringAsFixed(1),
                                          style: kProductPriceTextStyle,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 25,
                                      // color: Colors.blue,

                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            height: 30,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            width: 35,
                                            child: GestureDetector(
                                              onTap: () {
                                                _con.decrementQuantity(_con
                                                    .carts
                                                    .elementAt(index));
                                                // if (product.productQuantity >
                                                //     1) {
                                                //   setState(() {
                                                //     product.productQuantity =
                                                //         product.productQuantity -
                                                //             1;
                                                //     product.productTotalPrice =
                                                //         product.productTotalPrice -
                                                //             int.parse(product
                                                //                 .productPrice);
                                                //     promoText = '';
                                                //     _promo.clear();
                                                //   });
                                                // } else {
                                                //   cartProvider.cartProducts
                                                //       .remove(product);
                                                //   cartProvider.productNames
                                                //       .remove(
                                                //           product.productName);
                                                //   cartProvider.itemCount--;
                                                //   promoText = '';
                                                //   _promo.clear();
                                                // }
                                                // cartProvider
                                                //     .calculateTotalPrice();
                                              },
                                              child: Icon(
                                                Icons.remove,
                                                size: 16,
                                                color: kDarkGreen,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              product.quantity.toString(),
                                              textAlign: TextAlign.center,
                                              style: kProductNameTextStyle,
                                            ),
                                            width: 30,
                                          ),
                                          Container(
                                            width: 35,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                _con.incrementQuantity(_con
                                                    .carts
                                                    .elementAt(index));
                                                // setState(() {
                                                //   product.productQuantity =
                                                //       product.productQuantity +
                                                //           1;
                                                //   product.productTotalPrice =
                                                //       product.productTotalPrice +
                                                //           int.parse(product
                                                //               .productPrice);
                                                //   promoText = '';
                                                //   _promo.clear();
                                                // });
                                                // cartProvider
                                                //     .calculateTotalPrice();
                                              },
                                              child: Icon(Icons.add,
                                                  size: 16, color: kDarkGreen),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: cartList == null ? 0 : cartList.length,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: kDarkGreen,
                        child: FlatButton(
                          color: kDarkGreen,
                          onPressed: () {
                            cartProvider.grandTotal =
                                amount + deliveryCharge - discountGiven;
                            cartProvider.discount = discountGiven;
                            Navigator.pushNamed(context, 'addresses');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Place Order',
                                style: kCartOrderButtonTextStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '₹ ' + _con.total.toStringAsFixed(1),
                                style: kCartOrderButtonTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
