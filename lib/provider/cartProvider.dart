import 'package:flutter/material.dart';
import 'package:freshology/models/cartModel.dart';

class CartProvider extends ChangeNotifier {
  int itemCount = 0;
  List<CartModel> cartProducts = [];
  int totalValue = 0;
  int grandTotal = 0;
  int discount = 0;
  bool deliveryCharge = true;
  List<String> productNames = [];

  void calculateTotalPrice() {
    totalValue = 0;
    for (var p in cartProducts) {
      totalValue = totalValue + (int.parse(p.productPrice) * p.productQuantity);
    }
    notifyListeners();
  }

  void removeFromCart(CartModel item) {
    cartProducts.removeWhere((test) => test.productName == item.productName);
    productNames.remove(item.productName);
    itemCount = itemCount - 1;
    calculateTotalPrice();
  }

  void removeQuantity(CartModel item) {
    cartProducts.forEach((f) {
      if (f.productName == item.productName) {
        f.productQuantity = f.productQuantity - 1;
      }
    });
    calculateTotalPrice();
  }

  void addToCart(CartModel item) {
    if (productNames.contains(item.productName) == false) {
      cartProducts.add(item);
      itemCount++;
      productNames.add(item.productName);
    } else {
      cartProducts.forEach((f) {
        if (f.productName == item.productName) {
          f.productQuantity = f.productQuantity + 1;
        }
      });
    }
    calculateTotalPrice();
    notifyListeners();
  }
}
