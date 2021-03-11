import 'dart:async';
import 'dart:io';
import 'package:freshology/helpers/helper.dart';
import 'package:freshology/models/route.dart';
import 'package:freshology/screens/products.dart';
import 'package:get/get.dart';

import '../repositories/appListenables.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/controllers/home_controller.dart';
import 'package:freshology/functions/stringExtension.dart';
import 'package:freshology/provider/cartProvider.dart';
import 'package:freshology/provider/categoryProvider.dart';
import 'package:freshology/provider/offersProvider.dart';
import 'package:freshology/provider/orderProvider.dart';
import 'package:freshology/provider/productProvider.dart';
import 'package:freshology/provider/promoProvider.dart';
import 'package:freshology/provider/userProvider.dart';
import 'package:freshology/repositories/user_repository.dart';
import 'package:freshology/screens/orders.dart';
import 'package:freshology/screens/productDetails.dart';
import 'package:freshology/screens/wallet.dart';
import 'package:freshology/widget/CategoryWidget.dart';
import 'package:freshology/widget/HorizontalBannerWidget.dart';
import 'package:freshology/widget/VipUserDialog.dart';
import 'package:freshology/widget/announcement.dart';
import 'package:freshology/widget/bannerWidget.dart';
import 'package:freshology/widget/bannerWidgetCategory.dart';
import 'package:freshology/widget/categoryBox.dart';
import 'package:freshology/widget/productBox.dart';
import 'package:freshology/widget/floatingAppBar.dart';
import 'package:freshology/widget/trendingProductWidget.dart';
import 'package:get_version/get_version.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_slider/image_slider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:store_redirect/store_redirect.dart';

import 'cart.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends StateMVC<Home> with TickerProviderStateMixin {
  HomeController _con;

  _HomeState() : super(HomeController()) {
    _con = controller;
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _db = Firestore.instance;

  List<Container> carMockList = [
    Container(),
    Container(),
  ];
  double _total = 0;

  String offerImageUrl;
  bool _isOrders = true;
  bool _isPopup = false;
  String msg = '';
  String popTitle = '';
  String popMessage = '';
  String appVersion = '';
  ScrollController _scrollController;
  int _tabLength1 = 0;
  int _tabLength2 = 0;
  int _tabLength3 = 0;
  TabController tabController1;
  TabController tabController2;
  TabController tabController3;

  void getGeneralData() async {
    try {
      appVersion = await GetVersion.projectVersion;
    } on PlatformException {
      appVersion = 'Failed to get project version.';
    }
    bool _popDisplayed =
        Provider.of<PromoProvider>(context, listen: false).popDisplayed;
    bool _updatePopDisplayed =
        Provider.of<PromoProvider>(context, listen: false).updatePopup;
    var data = await _db.collection('general').document('home_offer').get();
    offerImageUrl = data.data['offer_url'];
    var d = await _db.collection('general').document('accepting').get();
    setState(() {
      _isOrders = d.data['orders'];
      msg = d.data['msg'];
    });
    var p = await _db.collection('general').document('pop_up').get();
    setState(() {
      _isPopup = p.data['show'];
      popTitle = p.data['title'];
      popMessage = p.data['msg'];
    });
    if (_isPopup == true && _popDisplayed == false) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                popTitle,
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              content: Text(
                popMessage,
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Provider.of<PromoProvider>(context, listen: false)
                        .popDisplayed = true;
                    Navigator.of(context).pop(false);
                  },
                )
              ],
            );
          });
    }
    var v = await _db.collection('general').document('update_popup').get();
    if (v.data['check'] == true && _updatePopDisplayed == false) {
      if (appVersion != v.data['version']) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                backgroundColor: Colors.white,
                title: Text(
                  'A new update is available!',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                content: Text(
                  'Please update the app to continue.',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Update'),
                    onPressed: () {
                      Provider.of<PromoProvider>(context, listen: false)
                          .updatePopup = true;
                      if (Platform.isAndroid) {
                        StoreRedirect.redirect(
                            androidAppId: 'com.flutterapp.freshology');
                        //com.flutterapp.freshology
                      } else if (Platform.isIOS) {
                        //1517619201
                        print('clicked');
                        StoreRedirect.redirect(iOSAppId: '1517619201');
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      }
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Are you sure?',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              content: Text(
                'Do you want to exit the app',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('YES'),
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _con.fetchSingleProduct("1");
      _con.fetchMainCategories();
      _con.fetchAnnouncement();
      _con.fetchBanners();
      _con.listenForCarts();
      _con.listenForSlider();

      _con.listenForTrendingFoods();
      getGeneralData();
      // Provider.of<ProductProvider>(context, listen: false).getFruitsAndVeg();

      // Provider.of<CategoryProvider>(context, listen: false).categories.clear();
      // Provider.of<ProductProvider>(context, listen: false)
      // .featuredProductList
      // .clear();
      Provider.of<OffersProvider>(context, listen: false).getProductOffers();
      Provider.of<OffersProvider>(context, listen: false).getCategoriesOffers();
      Provider.of<CategoryProvider>(context, listen: false).getCategories();
      // Provider.of<ProductProvider>(context, listen: false)
      //     .getFeaturedProducts();
      // Provider.of<ProductProvider>(context, listen: false).getProductNames();
      Provider.of<UserProvider>(context, listen: false).getUserDetail();
      Provider.of<OrderProvider>(context, listen: false).getUserDetail();
      _scrollController = ScrollController();
      tabController1 = TabController(length: 7, vsync: this);
      tabController2 = TabController(length: 6, vsync: this);
      tabController3 = TabController(length: 7, vsync: this);
    });
    _prevIndex = _selectedIndex;
    super.initState();
  }

////BOTTOM NAVIGATION BAR LOGIG
  int _selectedIndex = 1;
  int _prevIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Wallet(),
    Home(),
    Orders(),
    Cart()
  ];

  void _onItemTapped(int index) {
    _prevIndex = _selectedIndex;
    _total = _total + 2;
    setState(() {
      _selectedIndex = index;
    });
    if (_prevIndex == 3) {
      print("Listening for carts:");
      _con.listenForCarts();
      setState(() {});
    }
    print("PREVIOUS INDEX : $_prevIndex");
  }

  customNavigationBarItem(String label, IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Material(
        child: Container(
          height: 50,
          width: 50,
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: _selectedIndex == index ? kLightGreen : Colors.transparent,
              shape: BoxShape.circle),
          child: Column(
            children: [
              Icon(
                icon,
                color: _selectedIndex == index ? Colors.white : Colors.black,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: _selectedIndex == index ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
      label: label,
    );
  }

  customCartButtom(String label, IconData icon, int index, cartProvider) {
    if (_selectedIndex == index) {
      return BottomNavigationBarItem(
        icon: Material(
          child: Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color:
                    _selectedIndex == index ? kLightGreen : Colors.transparent,
                shape: BoxShape.circle),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: _selectedIndex == index ? Colors.white : Colors.black,
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        _selectedIndex == index ? Colors.white : Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
        label: label,
      );
    } else {
      return BottomNavigationBarItem(
        icon: Material(
          child: Container(
            height: 30,
            width: 200,
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                color: kLightGreen,
                width: 1.5,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Badge(
                  badgeColor: kLightGreen,
                  position: BadgePosition.topEnd(end: -3, top: 0),
                  showBadge: cartProvider.itemCount > 0 ? true : false,
                  child: Icon(
                    Icons.shopping_cart,
                    color: kDarkGreen,
                  ),
                  elevation: 0,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "₹ " + _total.toStringAsFixed(1),
                  // (cartProvider.totalValue == null
                  //     ? "${val}"
                  //     : cartProvider.totalValue.toString()),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        label: 'Home',
      );
    }
  }

  /////

  @override
  Widget build(BuildContext context) {
    _total = _con.total;
    // final names = Provider.of<ProductProvider>(context).productNames;
    // final searchRef = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    var size = MediaQuery.of(context).size;
    final categoryList = Provider.of<CategoryProvider>(context).categories;
    // final featuredList =
    //     Provider.of<ProductProvider>(context).featuredProductList;
    // final fruitsAndVegList =
    //     Provider.of<ProductProvider>(context).fruitsAndVegetables;
    // Provider.of<ProductProvider>(context).featuredProductList;
    final userProvider = Provider.of<UserProvider>(context);
    // final productProvider = Provider.of<ProductProvider>(context);
    final offersProvider = Provider.of<OffersProvider>(context);
    final offersList = Provider.of<OffersProvider>(context).offers;
    final categoryOfferList =
        Provider.of<OffersProvider>(context).categoryOffers;
    final user = currentUser.value;

    setState(() {
      _tabLength1 = offersProvider.offers.length;
      _tabLength2 = offersProvider.offers.length;
      _tabLength3 = offersProvider.offers.length;
    });

    List<Widget> _buildCategoryWidgetList() {
      List<Widget> _widgetList = [];
      _con.categories.forEach((category) {
        _widgetList.add(CategoryWidget(
          category: category,
          onPressed: (id) async {
            print("SUB CATEGORY ID: ${id}");
            _con.total = await Get.to(() => Products(
                routeArgument:
                    RouteArgument(param: category, id: id.toString())));
            setState(() {});
          },
        ));
        _widgetList.add(SizedBox(height: 10));
      });
      return _widgetList;
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        key: _con.scaffoldKey,
        child: Scaffold(
          drawer: Container(
            width: size.width,
            child: Drawer(
              child: SafeArea(
                right: false,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: kDarkGreen.withOpacity(0.15),
                          border: Border.all(
                            color: kDarkGreen,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: Image(
                                    image: AssetImage("assets/vip.png"),
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  children: [
                                    Text(
                                      "Become a VIP member",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("Unlimited free deliveries"),
                                  ],
                                )
                              ],
                            ),
                            Container(
                              child: RaisedButton(
                                color: kDarkGreen,
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialogBox();
                                      });
                                },
                                child: Text(
                                  "Subscribe Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    user.id != null
                        ? ListTile(
                            leading: Icon(
                              FontAwesomeIcons.userCircle,
                              color: Colors.black,
                            ),
                            title: Text(
                              'My Account',
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, 'account');
                            },
                          )
                        : Container(),
                    user.id != null
                        ? ListTile(
                            leading: Icon(
                              FontAwesomeIcons.addressBook,
                              color: Colors.black,
                            ),
                            title: Text(
                              'Addresses',
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, 'addresses');
                            },
                          )
                        : Container(),
                    user.id != null
                        ? ListTile(
                            leading: Icon(
                              FontAwesomeIcons.wallet,
                              color: Colors.black,
                            ),
                            title: Text('Freshology Cash'),
                            trailing: Text("₹ "),
                            onTap: () {
                              Navigator.pushNamed(context, 'wallet');
                            },
                          )
                        : Container(),
                    user.id != null
                        ? ListTile(
                            leading: Icon(
                              FontAwesomeIcons.shoppingBasket,
                              color: Colors.black,
                            ),
                            title: Text('My Orders'),
                            onTap: () {
                              Navigator.pushNamed(context, 'orders');
                            },
                          )
                        : Container(),
                    user.id != null
                        ? ListTile(
                            leading: Icon(
                              FontAwesomeIcons.heart,
                              color: Colors.black,
                            ),
                            title: Text('Favorites'),
                            onTap: () {
                              Navigator.pushNamed(context, 'favorites');
                            },
                          )
                        : Container(),
                    user.id != null
                        ? ListTile(
                            leading: Icon(
                              FontAwesomeIcons.moneyBillAlt,
                              color: Colors.black,
                            ),
                            title: Text('New Offers'),
                            onTap: () {
                              Navigator.pushNamed(context, 'orders');
                            },
                          )
                        : Container(),
                    // user.id != null
                    //     ? ListTile(
                    //         leading: Icon(
                    //           FontAwesomeIcons.addressCard,
                    //           color: Colors.black,
                    //         ),
                    //         title: Text('Delivery Address'),
                    //         onTap: () {
                    //           Navigator.pushNamed(context, 'address');
                    //         },
                    //       )
                    //     : Container(),
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.phoneAlt,
                        color: Colors.black,
                      ),
                      title: Text('Contact Us'),
                      onTap: () {
                        Navigator.pushNamed(context, 'contact');
                      },
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.solidStar,
                        color: Colors.black,
                      ),
                      title: Text('Rate our app'),
                      onTap: () {
                        // Navigator.pushNamed(context, 'contact');
                        Navigator.pop(context);
                        Helper.launchInWebView(
                            "https://play.google.com/store/apps/details?id=com.flutterapp.freshology");
                      },
                    ),
                    user.id != null
                        ? ListTile(
                            leading: Icon(
                              FontAwesomeIcons.shareSquare,
                              color: Colors.black,
                            ),
                            title: Text('Refer and earn'),
                            onTap: () {
                              Navigator.pushNamed(context, 'address');
                            },
                          )
                        : Container(),
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.share,
                        color: Colors.black,
                      ),
                      title: Text('Share'),
                      onTap: () {
                        Navigator.pushNamed(context, 'address');
                      },
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.userShield,
                        color: Colors.black,
                      ),
                      title: Text('Privacy Policy'),
                      onTap: () {
                        // Navigator.pushNamed(context, 'privacy');
                        Navigator.pop(context);
                        Helper.launchInWebView(
                            "https://freshology.in/privacy-policy/");
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.undoAlt,
                        color: Colors.black,
                      ),
                      title: Text('Return Policy'),
                      onTap: () {
                        // Navigator.pushNamed(context, 'refund');
                        Navigator.pop(context);
                        Helper.launchInWebView(
                            "https://freshology.in/return-policy/");
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.fileAlt,
                        color: Colors.black,
                      ),
                      title: Text('Terms and conditions'),
                      onTap: () {
                        // Navigator.pushNamed(context, 'terms');
                        Navigator.pop(context);
                        Helper.launchInWebView(
                            "https://freshology.in/terms-conditions/");
                      },
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    user.id != null
                        ? ListTile(
                            leading: Icon(
                              FontAwesomeIcons.signOutAlt,
                              color: Colors.black,
                            ),
                            title: Text('Logout'),
                            onTap: () {
                              _auth.signOut();
                              Navigator.pushNamed(context, 'login');
                            },
                          )
                        : ListTile(
                            leading: Icon(
                              FontAwesomeIcons.signInAlt,
                              color: Colors.black,
                            ),
                            title: Text('Login/Register'),
                            onTap: () {
                              Navigator.pushNamed(context, 'start');
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 65,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 0,
              iconSize: 20,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              unselectedItemColor: Colors.black,
              items: <BottomNavigationBarItem>[
                customNavigationBarItem(
                    "Wallet", Icons.account_balance_wallet, 0),
                customNavigationBarItem("Home", Icons.home, 1),
                customNavigationBarItem("Order", Icons.shopping_basket, 2),
                customCartButtom("Cart", Icons.shopping_cart, 3, cartProvider),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped,
            ),
          ),
          body: _selectedIndex == 1
              ? NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        iconTheme: IconThemeData(color: Colors.black),
                        // leading: Container(),
                        title: Container(
                          child: Image(
                            image: AssetImage(
                              'assets/logo_text.png',
                            ),
                            width: 200,
                            height: 50,
                          ),
                        ),
                        actions: [
                          Container(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'notify');
                              },
                              child: Icon(
                                Icons.notifications,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: 15)
                        ],
                        backgroundColor: Colors.white,
                        pinned: false,
                        floating: true,
                        forceElevated: innerBoxIsScrolled,
                        centerTitle: true,
                      ),
                    ];
                  },
                  body: SingleChildScrollView(
                      child: StickyHeader(
                    header: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 3,
                            offset:
                                Offset(01, 01), // changes position of shadow
                          ),
                        ],
                      ),
                      child: AutoCompleteTextField<String>(
                        itemSubmitted: (value) {
                          print(value);
                          // searchRef.searchItemName = value;
                          // Provider.of<ProductProvider>(context, listen: false)
                          //     .getSearchProduct(context);
                          FocusScope.of(context).unfocus();
                        },
                        key: null,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 1.5),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Search",
                        ),
                        // suggestions: names,
                        itemBuilder: (context, item) {
                          return ListTile(
                            leading: Icon(
                              Icons.search,
                              color: kLightGreen,
                            ),
                            title: Text(
                              item,
                            ),
                          );
                        },
                        itemSorter: (a, b) {
                          return a.compareTo(b);
                        },
                        itemFilter: (name, query) {
                          return name
                              .toLowerCase()
                              .contains(query.toLowerCase());
                        },
                      ),
                    ),
                    content: Center(
                      child: Column(
                        children: <Widget>[
                          (_con.slides1.length < 1 && !_con.showSlider)
                              ? Container()
                              : BannerScrollable(
                                  slidesList: _con.slides1,
                                  length: _con.slides1.length,
                                  onPressed: (i) async {
                                    _con.total = await Get.to(
                                      ProductDetails(
                                        routeArgument: RouteArgument(
                                          id: i.foodId.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          // SizedBox(height: 20),
                          // (offersProvider.offers.length > 0)
                          //     ? ImageSlider(
                          //         showTabIndicator: false,
                          //         tabIndicatorColor: Colors.lightBlue,
                          //         tabIndicatorSelectedColor:
                          //             Color.fromARGB(255, 0, 0, 255),
                          //         tabIndicatorHeight: 16,
                          //         tabIndicatorSize: 16,
                          //         tabController: tabController1,
                          //         curve: Curves.fastOutSlowIn,
                          //         width: size.width,
                          //         height: 220,
                          //         autoSlide: true,
                          //         duration: new Duration(seconds: 5),
                          //         allowManualSlide: true,
                          //         children: offersProvider.offers.length != 0
                          //             ? offersList.map((i) {
                          //                 return Builder(
                          //                     builder: (BuildContext context) {
                          //                   return Container(
                          //                     width: size.width,
                          //                     child: ClipRRect(
                          //                       borderRadius:
                          //                           BorderRadius.circular(5),
                          //                       child: GestureDetector(
                          //                         onTap: i.clickable != null
                          //                             ? () {
                          //                                 if (i.clickable ==
                          //                                     true) {
                          //                                   Navigator.push(
                          //                                     context,
                          //                                     MaterialPageRoute(
                          //                                         builder: (context) => ProductDetails(ProductModel(
                          //                                             price: i
                          //                                                 .price,
                          //                                             weight: i
                          //                                                 .weight,
                          //                                             description: i
                          //                                                 .description,
                          //                                             name: i
                          //                                                 .name,
                          //                                             sGST: i
                          //                                                 .sGST
                          //                                                 .toDouble(),
                          //                                             iGST: i
                          //                                                 .iGST
                          //                                                 .toDouble(),
                          //                                             cGST: i
                          //                                                 .cGST
                          //                                                 .toDouble(),
                          //                                             hSN:
                          //                                                 i.hSN,
                          //                                             sKU:
                          //                                                 i.sKU,
                          //                                             quantity:
                          //                                                 0,
                          //                                             imageUrl:
                          //                                                 i.image))),
                          //                                   );
                          //                                 }
                          //                               }
                          //                             : () {
                          //                                 productProvider
                          //                                         .selectedProduct =
                          //                                     ProductModel(
                          //                                   imageUrl: i.image,
                          //                                   description:
                          //                                       i.description,
                          //                                   price: i.price,
                          //                                   weight: i.weight,
                          //                                   name: i.name,
                          //                                   cGST: i.cGST,
                          //                                   sGST: i.sGST,
                          //                                   sKU: i.sKU,
                          //                                   iGST: i.iGST,
                          //                                   hSN: i.hSN,
                          //                                   quantity: 0,
                          //                                 );
                          //                               },
                          //                         child: Image(
                          //                           image:
                          //                               NetworkImage(i.offers),
                          //                           fit: BoxFit.cover,
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   );
                          //                 });
                          //               }).toList()
                          //             : carMockList,
                          //       )
                          //     : Container(),
                          // SizedBox(height: 10),
                          _isOrders
                              ? Container()
                              : Container(
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: kDarkGreen,
                                      width: 2,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(15),
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    msg ?? '',
                                    style: GoogleFonts.notoSans(
                                      textStyle: kCartGrandTotalTextStyle,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                          _con.showAnnouncement
                              ? AnnouncementWidget(
                                  announcement: _con.announcement)
                              : Container(),
                          SizedBox(height: 20),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.trending_up,
                                    color: kDarkGreen,
                                    size: 32,
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          "Trending this week",
                                          style: TextStyle(
                                            color: kDarkGreen,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: AutoSizeText(
                                          "Lorem Ipsum is simply dummy text ",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: _con.trendingProducts.length < 1
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [],
                                        ),
                                      ),
                                      Container(
                                        height: 285,
                                        child: GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 3.55 / 1.78,
                                            crossAxisCount: 1,
                                          ),
                                          itemCount:
                                              _con.trendingProducts.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: TrendingProductsWidget(
                                                product: _con
                                                    .trendingProducts[index],
                                                buttonPressed: () async {
                                                  _con.total = await Get.to(
                                                    ProductDetails(
                                                      routeArgument:
                                                          RouteArgument(
                                                        id: _con
                                                            .trendingProducts[
                                                                index]
                                                            .id
                                                            .toString(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                          ),

                          SizedBox(height: 20),
                          offerImageUrl != null
                              ? Container(
                                  width: size.width,
                                  child: Image(
                                    image: NetworkImage(offerImageUrl),
                                  ),
                                )
                              : Container(),
                          SizedBox(height: 20),

                          Column(
                            children: _buildCategoryWidgetList(),
                          ),
                          SizedBox(height: 20),
                          (_con.slides2.length < 1 && !_con.showSlider)
                              ? Container()
                              : BannerScrollable(
                                  slidesList: _con.slides2,
                                  length: _con.slides2.length,
                                  onPressed: (i) async {
                                    _con.total = await Get.to(
                                      ProductDetails(
                                        routeArgument: RouteArgument(
                                          id: i.foodId.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          SizedBox(height: 20),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.trending_up,
                                    color: kDarkGreen,
                                    size: 32,
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          "Trending this week",
                                          style: TextStyle(
                                            color: kDarkGreen,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: AutoSizeText(
                                          "Lorem Ipsum is simply dummy text ",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: _con.trendingProducts.length < 1
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [],
                                        ),
                                      ),
                                      Container(
                                        height: 285,
                                        child: GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 3.55 / 1.78,
                                            crossAxisCount: 1,
                                          ),
                                          itemCount:
                                              _con.trendingProducts.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: TrendingProductsWidget(
                                                product: _con
                                                    .trendingProducts[index],
                                                buttonPressed: () async {
                                                  _con.total = await Get.to(
                                                    ProductDetails(
                                                      routeArgument:
                                                          RouteArgument(
                                                        id: _con
                                                            .trendingProducts[
                                                                index]
                                                            .id
                                                            .toString(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          SizedBox(height: 20),
                          offerImageUrl != null
                              ? Container(
                                  width: size.width,
                                  child: Image(
                                    image: NetworkImage(offerImageUrl),
                                  ),
                                )
                              : Container(),

                          HorizontalBannerWidget(
                            bannerList: _con.adBanners,
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  )))
              : _widgetOptions.elementAt(_selectedIndex),

          //  _selectedIndex == 1
          //     ?
          //     : _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
    );
  }
}
