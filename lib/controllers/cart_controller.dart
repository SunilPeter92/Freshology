import 'package:flutter/material.dart';
import 'package:freshology/helpers/helper.dart';
import 'package:freshology/models/cart.dart';
import 'package:freshology/models/coupon.dart';
import 'package:freshology/models/favorite.dart';
import 'package:freshology/repositories/settings_repository.dart';
import 'package:freshology/widget/NoUserModal.dart';
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
  Favorite favorite;

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

  void listenForFavorite({String foodId}) async {
    final Stream<Favorite> stream = await isFavoriteFood(foodId);
    stream.listen((Favorite _favorite) {
      setState(() => favorite = _favorite);
    }, onError: (a) {
      print(a);
    });
  }

  void doApplyCoupon(String code, {String message}) async {
    coupon = new Coupon.fromJSON({"code": code, "valid": null});
    final Stream<Coupon> stream = await verifyCoupon(code);
    stream.listen((Coupon _coupon) async {
      print("DO APPLY COUPON ${_coupon.discount}");
      coupon = _coupon;
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Verify your internet connection"),
      ));
    }, onDone: () {
      print("COUPON LISTENIG FOR CARTS");
      listenForCarts();
    });
  }

  void addToFavorite(Product food) async {
    if (currentUser.value.apiToken == null) {
      showNoUserModal(context);
      // scaffoldKey.currentState.showSnackBar(SnackBar(
      //   content: Text('Please login/register to continue'),
      // ));
    } else {
      var _favorite = new Favorite();
      _favorite.food = food;
      _favorite.extras = food.extras.where((Extra _extra) {
        return _extra.checked;
      }).toList();
      addFavorite(_favorite).then((value) {
        setState(() {
          this.favorite = value;
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('This food was added to favorite'),
        ));
      });
    }
  }

  void removeFromFavorite(Favorite _favorite) async {
    removeFavorite(_favorite).then((value) {
      setState(() {
        this.favorite = new Favorite();
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('This food was removed from favorites'),
      ));
    });
  }

  void addmultiplecart(Cart cart) {}

  void listenForCarts({String message, bool withAddOrder = false}) async {
    carts.clear();
    if (currentUser.value.apiToken != null) {
      final Stream<Cart> stream = await getCart();
      stream.listen((Cart _cart) {
        if (!carts.contains(_cart)) {
          setState(() {
            coupon = _cart.product.applyCoupon(coupon);
            // print(
            //     "DISCOUNTED PRICE CALCULATED: ${_cart.product.extras[0].price}");
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
    } else {
      // showNoUserModal(context);
    }
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
    if (currentUser.value == null || currentUser.value.apiToken == null) {
      showNoUserModal(context);
      // scaffoldKey.currentState.showSnackBar(SnackBar(
      //   content: Text('Please login/register to continue'),
      // ));
    } else {
      if (product.deliverable) {
        setState(() {
          this.loadCart = true;
        });
        var _cart = new Cart();
        _cart.product = product;
        _cart.extras =
            product.extras.where((element) => element.checked).toList();
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
      } else {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Product not available currently'),
        ));
      }
    }
  }

  void removeFromCart(Cart _cart) async {
    removeCart(_cart).then((value) {
      if (value == "Deleted successfully") {
        setState(() {
          this.carts.remove(_cart);
        });
      } else {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Something went wrong"),
        ));
      }

      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("The ${_cart.product.name} was removed from your cart"),
      ));
      setState(() {
        carts = [];
      });
      listenForCarts();
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

  incrementQuantity(Cart cart) {
    print("INCREMENT CALLED: ${cart.quantity}");
    if (cart.quantity <= 99) {
      ++cart.quantity;
      updateCart(cart);
      calculateCartTotal();
    }
  }

  decrementQuantity(Cart cart) {
    print("DECREMENT CALLED: ${cart.quantity}");
    if (cart.quantity > 1) {
      --cart.quantity;
      updateCart(cart);
      calculateCartTotal();
    } else if (cart.quantity == 1.0) {
      print("DECREMENT ELSE IF CALLED");

      removeFromCart(cart);
    }
  }
}
