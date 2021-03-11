import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/controllers/favorite_controller.dart';
import 'package:freshology/models/route.dart';
import 'package:freshology/models/product.dart';

import 'package:freshology/screens/productDetails.dart';
import 'package:freshology/widget/productWidget.dart';
import 'package:get/get.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends StateMVC<Favorites> {
  FavoriteController _con;
  _FavoritesState() : super(FavoriteController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: kDarkGreen),
            title: Text(
              "Favorites",
              style: TextStyle(
                color: kDarkGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Column(
            children: [
              SizedBox(height: 20),
              _con.favorites.length < 1
                  ? Container()
                  : Flexible(
                      child: Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: _con.favorites.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 2 / 3.3),
                              itemBuilder: (BuildContext context, int index) {
                                // print(
                                //     "CON PRODUCTS : ${_con.products[index].name}");
                                return ProductWidget(
                                  product: _con.favorites[index].food,
                                  onPressed: () async {
                                    await Get.to(
                                      () => (ProductDetails(
                                        routeArgument: RouteArgument(
                                          id: _con.favorites[index].food.id
                                              .toString(),
                                        ),
                                      )),
                                    );
                                    setState(() {});
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          )),
    );
  }
}
