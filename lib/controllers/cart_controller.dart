import 'package:flutter/material.dart';
import 'package:freshology/helpers/helper.dart';
import 'package:freshology/models/cart.dart';
import 'package:freshology/models/product.dart';
import 'package:freshology/repositories/appListenables.dart';
import 'package:freshology/repositories/cart_repository.dart';
import 'package:freshology/repositories/product_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class CartController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  double taxAmount = 0.0;
  int cartCount = 0;
  Product product;
  double subTotal = 0.0;
  // double total = 0.0;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  double quantity = 1;
  double total = 0;
  Cart cart;
  // Favorite favorite;
  bool loadCart = false;

  CartController() {
    listenForCarts();
  }

  void listenForProduct({String productId, String message}) async {
    final Stream<Product> stream = await getProductById(productId);
    stream.listen((Product _product) {
      _product.media[0].url = Helper.imageURLFixer(_product.media[0].url);
      product = _product;
    }, onError: (a) {
      print(a);
      // scaffoldKey.currentState?.showSnackBar(SnackBar(
      //   content: Text('Verify your internet connection'),
      // ));
    }, onDone: () {
      setState(() {});
      if (message != null) {
        scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForCarts2({isGrocery = false, message}) async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      if (!carts.contains(_cart)) {
        setState(() {
          carts.add(_cart);
        });
      }
    }, onError: (a) {
      print(a);
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text('Verify your internet connection'),
      // ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void addmultiplecart(Cart cart) {}

  void listenForCarts({String message, isGrocery = false}) async {
    setState(() {
      loadCart = true;
    });
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      if (!carts.contains(_cart)) {
        setState(() {
          carts.add(_cart);
        });
      }
    }, onError: (a) {
      print(a);
    }, onDone: () {
      calculateSubtotal();
      print("RECALCULATED TOTAL: $total");
      setState(() {
        loadCart = false;
      });
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForCartsCount({String message}) async {
    final Stream<int> stream = await getCartCount();
    stream.listen((int _count) {
      setState(() {
        this.cartCount = _count;
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text('Verify your internet connection'),
      ));
    });
  }

  Future<void> refreshCarts() async {
    listenForCarts();
  }

  void addToCart(Product food, {bool reset = false}) async {
    setState(() {
      loadCart = true;
    });
    print(currentUser.value.apiToken);
    if (currentUser.value.apiToken == null) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please login/register to continue'),
      ));
    } else {
      var _cart = new Cart();
      _cart.product = food;
      // _cart.extras = food.extras.where((element) => element.checked).toList();
      _cart.quantity = this.quantity;
      addCart(_cart, reset).then((value) {
        setState(() {
          loadCart = false;
        });
        // calculateSubtotal();
        // refreshCarts();
        listenForCarts();
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('This food was added to cart'),
        ));
      });
    }
  }

  void removeFromCart(Cart _cart) async {
    removeCart(_cart).then((value) {
      setState(() {
        this.carts.remove(_cart);
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("The ${_cart.product.name} was removed from your cart"),
      ));
    });
  }

  void calculateSubtotal() {
    subTotal = 0;
    carts.forEach((cart) {
      subTotal = subTotal + (cart.quantity * cart.product.price);
    });
//    taxAmount = subTotal * settingRepo.setting.defaultTax / 100;
    total = subTotal + taxAmount;
    print("CALCULATED TOTAL: ${total}");
    setState(() {});
    // cartValue.value = total;
  }

  incrementQuantity(Cart cart) {
    if (cart.quantity <= 99) {
      ++cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  decrementQuantity(Cart cart) {
    if (cart.quantity > 1) {
      --cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }
}
