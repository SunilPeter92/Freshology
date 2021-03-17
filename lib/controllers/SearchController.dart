
import 'package:flutter/material.dart';
import 'package:freshology/helpers/helper.dart';
import 'package:freshology/models/product.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:freshology/repositories/product_repository.dart';
class SearchController extends ControllerMVC{
  List<Product> products = [];
  GlobalKey<ScaffoldState> scaffoldKey;
  bool isLoading = false;

  SearchController(){
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForSearch({String search}) async {
    setState(() {isLoading = true;});
    // Address _address = deliveryAddress.value;
    products =  [ ];
    final Stream<Product> stream = await searchProducts(search,);
    stream.listen((Product _product) {
      _product.media[0].url = Helper.imageURLFixer(_product.media[0].url);

      setState(() => products.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {
      setState(() {isLoading=false;});
    });
  }
}