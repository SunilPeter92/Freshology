import 'package:flutter/material.dart';
import 'package:freshology/functions/otpVerify.dart';
import 'package:freshology/models/route.dart';
import 'package:freshology/screens/address.dart';
import 'package:freshology/screens/cart.dart';
import 'package:freshology/screens/contact.dart';
import 'package:freshology/screens/favorites.dart';
import 'package:freshology/screens/home.dart';
import 'package:freshology/screens/item.dart';
import 'package:freshology/screens/login.dart';
import 'package:freshology/screens/myAdresses.dart';
import 'package:freshology/screens/notify.dart';
import 'package:freshology/screens/orderConfirm.dart';
import 'package:freshology/screens/orderDetails.dart';
import 'package:freshology/screens/orders.dart';
import 'package:freshology/screens/payment.dart';
import 'package:freshology/screens/privacyPolicy.dart';
import 'package:freshology/screens/productDetails.dart';
import 'package:freshology/screens/products.dart';
import 'package:freshology/screens/refundPolicy.dart';
import 'package:freshology/screens/register.dart';
import 'package:freshology/screens/settings.dart';
import 'package:freshology/screens/start.dart';
import 'package:freshology/screens/termsAndConditions.dart';
import 'package:freshology/screens/wallet.dart';

import 'screens/account.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
//      case '/Debug':
//        return MaterialPageRoute(builder: (_) => DebugWidget(routeArgument: args as RouteArgument));
      case 'start':
        return MaterialPageRoute(builder: (_) => Start());

      case 'home':
        return MaterialPageRoute(builder: (_) => Home());

      // case 'item':
      //   return MaterialPageRoute(builder: (_) => Item());

      case 'products':
        return MaterialPageRoute(
            builder: (_) => Products(routeArgument: args as RouteArgument));
      case 'favorites':
        return MaterialPageRoute(builder: (_) => Favorites());

      case 'productDetails':
        return MaterialPageRoute(
            builder: (_) =>
                ProductDetails(routeArgument: args as RouteArgument));

      case 'cart':
        return MaterialPageRoute(builder: (_) => Cart());

      case 'login':
        return MaterialPageRoute(builder: (_) => Login());

      case 'otp':
        return MaterialPageRoute(
            builder: (_) => OtpVerify(routeArgument: args as RouteArgument));

      case 'register':
        return MaterialPageRoute(builder: (_) => Register());

      case 'payment':
        return MaterialPageRoute(builder: (_) => Payment());

      case 'wallet':
        return MaterialPageRoute(builder: (_) => Wallet());

      case 'contact':
        return MaterialPageRoute(builder: (_) => Contact());

      case 'notify':
        return MaterialPageRoute(builder: (_) => Notify());
      case 'privacy':
        return MaterialPageRoute(builder: (_) => Privacy());
      case 'refund':
        return MaterialPageRoute(builder: (_) => Refund());
      case 'terms':
        return MaterialPageRoute(builder: (_) => Terms());
      case 'orders':
        return MaterialPageRoute(builder: (_) => Orders());
      // case 'orderDetails':
      //   return MaterialPageRoute(builder: (_) => OrderDetails());
      case 'setting':
        return MaterialPageRoute(builder: (_) => Setting());
      case 'confirm':
        return MaterialPageRoute(builder: (_) => OrderConfirm());
      case 'address':
        return MaterialPageRoute(
            builder: (_) => AddressEdit(routeArgument: args as RouteArgument));
      case 'account':
        return MaterialPageRoute(builder: (_) => Account());
      case 'addresses':
        return MaterialPageRoute(builder: (_) => Addresses());

      //   return MaterialPageRoute(
      //       builder: (_) =>
      //           RestaurentDetailScreen(routeArgument: args as RouteArgument));

    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
