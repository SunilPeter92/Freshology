import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/controllers/cart_controller.dart';
import 'package:freshology/models/cartModel.dart';
import 'package:freshology/models/product.dart';
import 'package:freshology/models/route.dart';
import 'package:freshology/models/userModel.dart';
import 'package:freshology/provider/cartProvider.dart';
import 'package:freshology/provider/productProvider.dart';
import 'package:freshology/provider/userProvider.dart';
import 'package:freshology/repositories/user_repository.dart';
import 'package:freshology/widget/CartButton.dart';
import 'package:freshology/widget/startButton.dart';
import 'package:get/get.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import '../repositories/appListenables.dart';

class ProductDetails extends StatefulWidget {
  RouteArgument routeArgument;
  ProductDetails({Key key, this.routeArgument}) : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends StateMVC<ProductDetails> {
  CartController _con;

  _ProductDetailsState() : super(CartController()) {
    _con = controller;
  }
  var _size;
  addMoneyPresetWidget(String weight, String price) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color:
              _con.extrasController.text == weight ? kDarkGreen : kLightGreen,
        ),
        borderRadius: BorderRadius.circular(15),
        color: _con.extrasController.text == weight ? kDarkGreen : Colors.white,
      ),
      child: GestureDetector(
        onTap: () {
          _con.product.extras.forEach((element) {
            element.checked = false;
          });
          setState(() {
            _con.extrasController.text = weight;

            Extra selectedExtra = _con.product.extras
                .firstWhere((element) => element.name == weight);
            for (int i = 0; i < _con.product.extras.length; i++) {
              if (_con.product.extras[i].name == weight) {
                _con.product.extras[i].checked = true;
                // _con.product.price = _con.product.extras[i].price;
                print("EXTRA CHECKED");
              } else {
                _con.product.extras[i].checked = false;
              }
            }
          });
        },
        child: Column(
          children: [
            Text(
              "${weight}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _con.extrasController.text == weight
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            Text(
              "₹ ${price}",
              style: TextStyle(
                fontSize: 12,
                color: _con.extrasController.text == weight
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildVariations() {
    List<Widget> variationsList = [];
    _con.product.extras.forEach((variation) {
      variationsList.add(
        addMoneyPresetWidget(
          variation.name.toString(),
          variation.price.toString(),
        ),
      );
    });

    return variationsList;
  }

  //////// TODO: MAKE USER OBJECT MANAGED BY STATE ////////
  User user;
  @override
  void initState() {
    // TODO: implement initState
    if (widget.routeArgument.id == null) {
      _con.product = widget.routeArgument.param;
    } else {
      _con.listenForProduct(productId: widget.routeArgument.id);
      _con.listenForFavorite(foodId: widget.routeArgument.id);
    }
    user = currentUser.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    final cartProvider = Provider.of<CartProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        await Future.delayed(Duration(milliseconds: 200), () {});
        setState(() {});
        Get.back(result: _con.total);
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        key: _con.scaffoldKey,
        bottomSheet: Container(
          width: _size.width,
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "QUANTITY",
                style: TextStyle(
                  color: kDarkGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _con.addToCart(_con.product);
                },
                child: Container(
                  width: 100,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Add +",
                    style: TextStyle(
                      fontSize: 14,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                    border: Border.all(
                      color: kDarkGreen,
                      width: 2,
                    ),
                  ),
                ),
              )
            ],
          ),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border.all(color: Colors.grey, width: 0.8)),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: kLightGreen,
              shape: BoxShape.circle,
            ),
            child: GestureDetector(
              onTap: () async {
                await Future.delayed(Duration(milliseconds: 200), () {});
                setState(() {});
                Get.back(result: _con.total);
                return true;
              },
              child: Icon(
                Icons.arrow_back,
              ),
            ),
          ),
          actions: [
            _con.loadCart
                ? Container(
                    height: 50,
                    width: 50,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : CartButton(
                    cartTotal: _con.total,
                  ),
          ],
        ),
        body: _con.product == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 270,
                      width: _size.width,
                      child: Image(
                        fit: BoxFit.contain,
                        image: NetworkImage(_con.product.media[0].url),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      width: _size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: _size.width * 0.65,
                            alignment: Alignment.topLeft,
                            child: AutoSizeText(
                              "${_con.product.name}",
                              maxFontSize: 20,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: _size.width * 0.28,
                            alignment: Alignment.centerRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "₹ ${_con.product.extras[0].price}",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "${_con.product.extras[0].price}",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              "Availability: ${_con.product.deliverable ? 'In Stock' : 'Out of Stock'}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _con.favorite?.id != null?_con.removeFromFavorite(_con.favorite)
                              : _con.addToFavorite(_con.product);
                              // _con.product.isFavorite?_con.removeFromFavorite(_)
                            },
                            child: Container(
                              child: Icon(_con.favorite?.id != null
                                  ? FontAwesomeIcons.solidHeart
                                  : FontAwesomeIcons.heart),
                            ),
                          ),
                          // Container(
                          //   child: Text(
                          //     "${widget.product.deliveryDate.day}/${widget.product.deliveryDate.month}/${widget.product.deliveryDate.year}",
                          //     style: TextStyle(
                          //       color: kDarkGreen,
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Container(
                      height: _size.height * 0.18,
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(10),
                      child: AutoSizeText(
                        _con.product.description == null
                            ? ""
                            : _con.product.description,
                        textAlign: TextAlign.left,
                        minFontSize: 10,
                        style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                      ),
                    ),
                    // SizedBox(height: 5),
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: _buildVariations()),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
