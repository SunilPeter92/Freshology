import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshology/models/categoryModel.dart';
import 'package:freshology/models/offerModel.dart';

class OffersProvider extends ChangeNotifier {
  List<OffersModel> offers = [];
  Firestore _fireStore = Firestore.instance;
  List<CategoryModel> categoryOffers = [];
  Firestore _db = Firestore.instance;

  Future<void> getCategoriesOffers() async {
    var data = await _db
        .collection('products')
        .document('fresh')
        .collection('categories')
        .getDocuments();
    for (var d in data.documents) {
      categoryOffers.add(CategoryModel(
        name: d.data['name'],
        imageUrl: d.data['imageUrl'],
      ));
    }
    notifyListeners();
  }

  Future<void> getProductOffers() async {
    offers.clear();
    var data = await _fireStore.collection('offers').getDocuments();
    for (var d in data.documents) {
      offers.add(OffersModel(
        offers: d.data['offerUrl'],
        price: d.data['price'],
        weight: d.data['weight'],
        description: d.data['description'],
        name: d.data['name'],
        image: d.data['image'],
        sGST: d.data['SGST'].toDouble(),
        iGST: d.data['IGST'].toDouble(),
        cGST: d.data['CGST'].toDouble(),
        hSN: d.data['HSN/SAC'],
        sKU: d.data['SKU'],
        clickable: d.data['clickable'],
        category: d.data['category'],
      ));
    }
    notifyListeners();
  }
}
