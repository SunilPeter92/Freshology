import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freshology/models/cart.dart';
import 'package:freshology/models/order.dart';
import 'package:freshology/models/order_status.dart';
import 'package:freshology/models/payment.dart';
import 'package:freshology/models/product_order.dart';
import 'package:freshology/repositories/cart_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:freshology/repositories/user_repository.dart' as userRepo;
import 'package:freshology/repositories/order_repository.dart' as orderRepo;

class CheckoutController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  Payment payment;
  double taxAmount = 0.0;
  double subTotal = 0.0;
  double total = 0.0;
  // CreditCard creditCard = new CreditCard();
  bool loading = true;
  GlobalKey<ScaffoldState> scaffoldKey;

  CheckoutController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForCarts();
    // listenForCreditCard();
  }

  // void listenForCreditCard() async {
  //   creditCard = await userRepo.getCreditCard();
  //   setState(() {});
  // }

  void listenForCarts({String message, bool withAddOrder = false}) async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      if (!carts.contains(_cart)) {
        setState(() {
          carts.add(_cart);
        });
      }
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text('Verify your internet connection'),
      ));
    }, onDone: () {
      calculateSubtotal();
      if (withAddOrder != null && withAddOrder == true) {
        addOrder(carts);
      }
      if (withAddOrder == false) {
        setState(() {
          loading = false;
        });
      }
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });

    subTotal = 100.0;
    taxAmount = 10.0;
    total = 110.0;
  }

  void addOrder(List<Cart> carts) async {
    Order _order = new Order();
    _order.productOrders = new List<ProductOrder>();
    _order.tax = 5.0;
    ;
    OrderStatus _orderStatus = new OrderStatus();
    _orderStatus.id = '1'; // TODO default order status Id
    _order.orderStatus = _orderStatus;
    carts.forEach((_cart) {
      ProductOrder _foodOrder = new ProductOrder();
      _foodOrder.quantity = _cart.quantity;
      _foodOrder.price = _cart.product.price;
      _foodOrder.food = _cart.product;
      _foodOrder.extras = _cart.extras;
      _order.productOrders.add(_foodOrder);
    });
    orderRepo.addOrder(_order, this.payment).then((value) {
      if (value is Order) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  void calculateSubtotal() async {
    subTotal = 0;
    carts.forEach((cart) {
      subTotal += cart.quantity * cart.product.price;
    });
    taxAmount = subTotal * 3 / 100;
    total = subTotal + taxAmount;
    setState(() {});
  }

  // void updateCreditCard(CreditCard creditCard) {
  //   userRepo.setCreditCard(creditCard).then((value) {
  //     setState(() {});
  //     scaffoldKey.currentState.showSnackBar(SnackBar(
  //       content: Text('Payment card updated successfully'),
  //     ));
  //   });
  // }
}
