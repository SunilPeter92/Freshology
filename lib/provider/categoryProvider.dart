import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:freshology/models/MainCategoryModel.dart';
import 'package:freshology/models/categoryModel.dart';

import 'package:http/http.dart' as http;
import 'package:freshology/constants/configurations.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> categories = [];
  List<String> categoriesNames = [];
  Firestore _db = Firestore.instance;
  // List<MainCategoryModel> mainCategory = [];
  Future<void> getCategories() async {
    var data = await _db
        .collection('products')
        .document('fresh')
        .collection('categories')
        .getDocuments();
    for (var d in data.documents) {
      categories.add(CategoryModel(
        name: d.data['name'],
        imageUrl: d.data['imageUrl'],
      ));
      categoriesNames.add(d.data['name']);
    }
    notifyListeners();
  }

  // getMainCategories() async {
  //   final url = "${baseURL}get_products";
  //   final response = await http.get(url);
  //   if ((response.statusCode == 200) || (response.statusCode == 201)) {
  //     var _data = json.decode(response.body);
  //     for (var cat in _data['data']) {
  //       mainCategory.add(MainCategoryModel.fromJson(cat));
  //     }
  //     print(mainCategory[0].name);
  //   } else {}
  // }
}
