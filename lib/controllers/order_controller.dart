import 'package:flutter/material.dart';
import 'package:freshology/models/order.dart';
import 'package:freshology/repositories/order_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class OrderController extends ControllerMVC {
  List<Order> orders = [];
  bool isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void listenForOrders({String message}) async {
    isLoading = true;
    final Stream<Order> stream = await getOrders();
    stream.listen((Order _order) {
      setState(() {
        orders.add(_order);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Verify your internet connection'),
      ));
    }, onDone: () {
      setState(() {
        isLoading = false;
      });
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }
}
