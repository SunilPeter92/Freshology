import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/models/cart.dart';
import 'package:freshology/models/order.dart';
import 'package:freshology/models/order_status.dart';
import 'package:freshology/models/payment.dart';
import 'package:freshology/models/product_order.dart';
import 'package:freshology/repositories/cart_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:freshology/repositories/user_repository.dart' as userRepo;
import 'package:freshology/repositories/order_repository.dart' as orderRepo;
import 'package:somedialog/somedialog.dart';

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
      // calculateSubtotal();
      if (withAddOrder != null && withAddOrder == true) {
        addOrder(carts);
      }
      if (withAddOrder == false) {
        setState(() {
          calculateSubtotal();
          loading = false;
        });
      }
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void addOrder(List<Cart> carts) async {
    loading = true;
    setState(() {});
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
      loading = false;
      if (value is Order) {
        Navigator.pushReplacementNamed(context, 'home');
        SomeDialog(
            context: context,
            path: "assets/order_success.json",
            mode: SomeMode.Lottie,
            content: "",
            title: "Order Placed",
            buttonConfig: ButtonConfig(
                dialogDone: "Alright!", buttonDoneColor: kLightGreen),
            submit: () {
              // Navigator.pop(context);
            });
        setState(() {
          loading = false;
        });
      }
    });
  }

  void calculateSubtotal() async {
    // subTotal = 0;
    // double extraPrice = 0.0;
    // carts.forEach((element) {
    //   extraPrice = (extraPrice + element.extras[0].price).toDouble();
    // });
    // carts.forEach((cart) {
    //   // subTotal += cart.quantity * extraPrice;
    //   subTotal += cart.quantity * cart.extras[0].price;
    // });

    // // deliveryFee = carts[0].food.restaurant.deliveryFee;
    // // taxAmount = (subTotal + deliveryFee) * settingRepo.setting.value.defaultTax / 100;
    // total = subTotal + extraPrice;
    // setState(() {});
    double _grossTotal = 0;
    double _allExtrasTotal = 0;
    carts.forEach((c) {
      _allExtrasTotal = _allExtrasTotal + c.extras[0].price;
    });
    _grossTotal = _allExtrasTotal;
    total = _grossTotal;
    setState(() {});
  }
  // void calculateSubtotal() async {
  //   subTotal = 0;
  //   carts.forEach((cart) {
  //     subTotal += cart.quantity * cart.product.price;
  //   });
  //   // deliveryFee = 0.0;
  //   // taxAmount = (subTotal) * settingRepo.setting.value.defaultTax / 100;
  //   total = subTotal;
  //   setState(() {});
  // }

  // void calculateSubtotal() async {
  //   subTotal = 0;
  //   double extraPrice = 0;
  //   carts.forEach((cart) {
  //     subTotal += cart.quantity * cart.product.price;
  //     cart.product.extras.forEach((extra) {
  //       extraPrice += extra.checked ? extra.price : 0;
  //     });
  //   });
  //   taxAmount = subTotal * 3 / 100;
  //   total = subTotal + taxAmount + extraPrice;
  //   setState(() {});
  // }

  void calculateTotal() {}

  // void updateCreditCard(CreditCard creditCard) {
  //   userRepo.setCreditCard(creditCard).then((value) {
  //     setState(() {});
  //     scaffoldKey.currentState.showSnackBar(SnackBar(
  //       content: Text('Payment card updated successfully'),
  //     ));
  //   });
  // }
}
