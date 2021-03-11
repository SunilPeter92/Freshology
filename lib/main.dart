import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/provider/cartProvider.dart';
import 'package:freshology/provider/categoryProvider.dart';
import 'package:freshology/provider/offersProvider.dart';
import 'package:freshology/provider/orderProvider.dart';
import 'package:freshology/provider/productProvider.dart';
import 'package:freshology/provider/promoProvider.dart';
import 'package:freshology/provider/userProvider.dart';
import 'package:freshology/route_generator.dart';
import 'package:freshology/screens/account.dart';
import 'package:freshology/screens/home.dart';
import 'package:freshology/screens/myAdresses.dart';
import 'package:freshology/screens/productDetails.dart';
import 'package:freshology/screens/start.dart';
import 'package:freshology/widget/bottom_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'functions/otpVerify.dart';
import 'screens/address.dart';
import 'screens/cart.dart';
import 'screens/contact.dart';
import 'screens/item.dart';
import 'screens/login.dart';
import 'screens/notify.dart';
import 'screens/orderConfirm.dart';
import 'screens/orderDetails.dart';
import 'screens/orders.dart';
import 'screens/payment.dart';
import 'screens/privacyPolicy.dart';
import 'screens/products.dart';
import 'screens/refundPolicy.dart';
import 'screens/register.dart';
import 'screens/settings.dart';
import 'screens/splashScreen.dart';
import 'screens/termsAndConditions.dart';
import 'screens/wallet.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage : $message");
        final snackBar = SnackBar(
          content: Text(message['notification']['title']),
          action: SnackBarAction(
            label: "Done",
            onPressed: () => null,
          ),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume : $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch : $message");
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),
        // ChangeNotifierProvider(
        //   create: (_) => ProductProvider(),
        // ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OffersProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PromoProvider(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: kDarkGreen,
          accentColor: kLightGreen,
          textTheme: GoogleFonts.notoSansTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: AnimatedSplashScreen(),
        // home: Register(),
        initialRoute: 'splash',
        onGenerateRoute: RouteGenerator.generateRoute,
        // routes: {
        //   'start': (context) => Start(),
        //   'home': (context) => Home(),
        //   'item': (context) => Item(),
        //   'products': (context) => Products(),
        //   'cart': (context) => Cart(),
        //   'login': (context) => Login(),
        //   'otp': (context) => OtpVerify(),
        //   'register': (context) => Register(),
        //   'payment': (context) => Payment(),
        //   'wallet': (context) => Wallet(),
        //   'contact': (context) => Contact(),
        //   'notify': (context) => Notify(),
        //   'privacy': (context) => Privacy(),
        //   'refund': (context) => Refund(),
        //   'terms': (context) => Terms(),
        //   'orders': (context) => Orders(),
        //   'orderDetails': (context) => OrderDetails(),
        //   'setting': (context) => Setting(),
        //   'confirm': (context) => OrderConfirm(),
        //   'address': (context) => AddressEdit(),
        //   'account': (context) => Account(),
        //   'addresses': (context) => Addresses(),
        // },
      ),
    );
  }
}
