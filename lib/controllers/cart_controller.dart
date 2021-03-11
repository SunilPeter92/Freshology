import 'package:flutter/material.dart';
import 'package:freshology/helpers/helper.dart';
import 'package:freshology/models/cart.dart';
import 'package:freshology/models/favorite.dart';
import 'package:freshology/models/product.dart';
import 'package:freshology/repositories/appListenables.dart';
import 'package:freshology/repositories/cart_repository.dart';
import 'package:freshology/repositories/favorite_repository.dart';
import 'package:freshology/repositories/product_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class CartController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  double taxAmount = 0.0;
  int cartCount = 0;
  Product product;
  double subTotal = 0.0;
  TextEditingController extrasController = TextEditingController();
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
    }, onDone: () async {
      final Stream<Favorite> favStream =
          await isFavoriteFood(product.id.toString());
      favStream.listen((_fav) {
        if (_fav != null || _fav.id != null) ;
        product.isFavorite = true;
      });

      setState(() {
        product.extras[0].checked = true;
        extrasController.text = product.extras[0].name;
      });
      if (message != null) {
        scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void addmultiplecart(Cart cart) {}

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
        content: Text("Verify your internet connection"),
      ));
    }, onDone: () {
      calculateCartTotal();
      // if (withAddOrder != null && withAddOrder == true) {
      //   addOrder(carts);
      // }
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  // void listenForCarts({String message, isGrocery = false}) async {
  //   setState(() {
  //     loadCart = true;
  //   });
  //   final Stream<Cart> stream = await getCart();
  //   stream.listen((Cart _cart) {
  //     if (!carts.contains(_cart)) {
  //       setState(() {
  //         carts.add(_cart);
  //       });
  //     }
  //   }, onError: (a) {
  //     print(a);
  //   }, onDone: () async {
  //     await calculateSubtotal();
  //     print("RECALCULATED TOTAL: $total");
  //     setState(() {
  //       loadCart = false;
  //     });
  //     if (message != null) {
  //       scaffoldKey.currentState.showSnackBar(SnackBar(
  //         content: Text(message),
  //       ));
  //     }
  //   });
  // }

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

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      cart = _cart;
      // calculateTotal();
    });
  }

  Future<void> refreshCarts() async {
    listenForCarts();
  }

  void addToCart(Product product, {bool reset = false}) async {
    setState(() {
      this.loadCart = true;
    });
    var _cart = new Cart();
    _cart.product = product;
    _cart.extras = product.extras.where((element) => element.checked).toList();
    // _cart.extras = product.extras;
    _cart.quantity = this.quantity;
    addCart(_cart, reset).then((value) {
      // listenForCart();
      cart = _cart;
      setState(() {
        this.loadCart = false;
        listenForCarts();
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('This food was added to cart'),
      ));
    });
  }

  // void addToCart({bool reset = false}) async {
  //   setState(() {
  //     loadCart = true;
  //   });
  //   print(currentUser.value.apiToken);
  //   if (currentUser.value.apiToken == null) {
  //     scaffoldKey.currentState.showSnackBar(SnackBar(
  //       content: Text('Please login/register to continue'),
  //     ));
  //   } else {
  //     var _cart = new Cart();
  //     _cart.product = product;

  //     _cart.extras =
  //         product.extras.where((element) => element.checked).toList();
  //     _cart.product.price = _cart.extras[0].price;
  //     _cart.quantity = this.quantity;
  //     cart = _cart;
  //     _cart.extras[0].price = 0.0;

  //     // _cart.extras =
  //     //     product.extras.where((element) => element.checked).toList();

  //     _cart.quantity = this.quantity;
  //     addCart(_cart, reset).then((value) {
  //       setState(() {
  //         loadCart = false;
  //       });
  //       // calculateSubtotal();
  //       // refreshCarts();
  //       listenForCarts();
  //       // calculateSubtotal();
  //       scaffoldKey.currentState.showSnackBar(SnackBar(
  //         content: Text('This food was added to cart'),
  //       ));
  //     });
  //   }
  // }

  // void calculateTotal() {
  //   total = product.price ?? 0;
  //   product.extras.forEach((extra) {
  //     total += extra.checked ? extra.price : 0;
  //   });
  //   total *= quantity;
  //   setState(() {});
  // }

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

  calculateCartTotal() {
    double _grossTotal = 0;
    double _allExtrasTotal = 0;
    carts.forEach((c) {
      _allExtrasTotal = _allExtrasTotal + (c.extras[0].price * c.quantity);
    });
    _grossTotal = _allExtrasTotal;
    total = _grossTotal;
    setState(() {});
  }

  void calculateSubtotal() async {
    subTotal = 0;
    double extraPrice = 0.0;
    carts.forEach((element) {
      extraPrice = (extraPrice + element.extras[0].price).toDouble();
    });
    carts.forEach((cart) {
      // subTotal += cart.quantity * extraPrice;
      subTotal += cart.quantity * cart.extras[0].price;
    });

    // deliveryFee = carts[0].food.restaurant.deliveryFee;
    // taxAmount = (subTotal + deliveryFee) * settingRepo.setting.value.defaultTax / 100;
    total = subTotal + extraPrice;
    setState(() {});
  }
//   void calculateSubtotal() async {
// //     subTotal = 0;
// //     carts.forEach((cart) {
// //       subTotal += cart.quantity * cart.product.price;
// //     });
// // //    taxAmount = subTotal * settingRepo.setting.defaultTax / 100;
// //     total = subTotal + taxAmount;
// //     setState(() {});
//     subTotal = 0;
//     double extraPrice = 0;
//     carts.forEach((cart) {
//       subTotal += cart.quantity * cart.product.price;

//       // cart.product.extras.forEach((extra) {
//       //   extraPrice += extra.checked ? extra.price : 0;
//       // });
//     });
//     taxAmount = 0;
//     total = subTotal + taxAmount + extraPrice;
//     setState(() {});
//   }

//   void calculateSubtotal() {
//     subTotal = 0;
//     double extraAmount = 0.0;
//     carts.forEach((cart) {
//       subTotal = subTotal + (cart.quantity * cart.product.price);
//     });
//     // print("CART EXTRASS SUB TOTAL: ${cart.extras.length}");
// // taxAmount = subTotal * settingRepo.setting.defaultTax / 100;
//     if (cart.extras.length > 0 || cart.extras != null)
//       extraAmount = cart.extras[0].price;
//     // print("PRODUCT EXTRAS: ${cart.extras}");
//     total = subTotal + taxAmount + extraAmount;
//     print("CALCULATED TOTAL: ${total}");
//     setState(() {});
//     // cartValue.value = total;
//   }

  incrementQuantity(Cart cart) {
    if (cart.quantity <= 99) {
      ++cart.quantity;
      updateCart(cart);
      calculateCartTotal();
    }
  }

  decrementQuantity(Cart cart) {
    if (cart.quantity > 1) {
      --cart.quantity;
      updateCart(cart);
      calculateCartTotal();
    }
  }
}
