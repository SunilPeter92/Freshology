import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshology/constants/configurations.dart';
// import 'package:freshology/models/MainCategoryModel.dart';
import 'package:freshology/models/productModel.dart';
import 'package:freshology/screens/productDetails.dart';
import 'package:http/http.dart' as http;

class ProductProvider extends ChangeNotifier {
  List<ProductModel> featuredProductList = [];
  List<ProductModel> fruitsProductList = [];
  List<ProductModel> vegetablesProductList = [];
  List<ProductModel> fruitsAndVegetables = [];
  List<ProductModel> cat1ProductList = [];
  List<ProductModel> cat2ProductList = [];
  List<ProductModel> cat3ProductList = [];
  List<ProductModel> cat4ProductList = [];
  List<ProductModel> productList = [];

  String selectedCategoryName;
  Firestore _db = Firestore.instance;
  bool isSearching = false;
  String searchItemName;
  ProductModel selectedProduct = ProductModel(
    name: 'No Product found',
    price: '?',
    weight: '?',
    imageUrl: '',
    sGST: 0,
    iGST: 0,
    cGST: 0,
    hSN: '',
    sKU: '',
    description: '',
    quantity: 0,
  );
  List<String> productNames = [];
  bool loadingProducts = false;

  void toggleLoadProducts() {
    loadingProducts = !loadingProducts;
    notifyListeners();
  }

  void toggleBool() {
    isSearching = !isSearching;
    notifyListeners();
  }

  bool checkProductStatus(var product) {
    //print(product.data['name'] + " = " + product.data['availability'].toString());
    if (product.data['availability'] == false) {
      return false;
    }
    return true;
  }

  Future<void> getSearchProduct(BuildContext ctx) async {
    String item = searchItemName.trim().toLowerCase();
    toggleBool();
    selectedProduct = ProductModel(
      name: 'No Product found',
      price: '?',
      weight: '?',
      imageUrl: '',
      sGST: 0,
      iGST: 0,
      cGST: 0,
      hSN: '',
      sKU: '',
      quantity: 0,
    );
    bool _performBreak = false;
    var data = await _db
        .collection('products')
        .document('fresh')
        .collection('categories')
        .getDocuments();
    for (var d in data.documents) {
      String docID = d.documentID;
      var products = await _db
          .collection('products')
          .document('fresh')
          .collection('categories')
          .document(docID)
          .collection('items')
          .getDocuments();
      for (var p in products.documents) {
        String searchedItem = p.data['name'].toString().toLowerCase();
        if (searchedItem == item) {
          selectedCategoryName = docID;
          selectedProduct.name = p.data['name'];
          selectedProduct.price = p.data['price'];
          selectedProduct.weight = p.data['weight'];
          selectedProduct.imageUrl = p.data['imageUrl'];
          selectedProduct.cGST = p.data['CGST'].toDouble();
          selectedProduct.sGST = p.data['SGST'].toDouble();
          selectedProduct.iGST = p.data['IGST'].toDouble();
          selectedProduct.hSN = p.data['HSN/SAC'];
          selectedProduct.sKU = p.data['SKU'];
          _performBreak = true;
          break;
        }
      }
      if (_performBreak == true) {
        break;
      }
    }
    toggleBool();
    var product = selectedProduct;
    // Navigator.push(
    //   ctx,
    //   MaterialPageRoute(builder: (context) => ProductDetails(product)),
    // );
    notifyListeners();
  }

  getFruitsAndVeg() async {
    vegetablesProductList.clear();
    var data = await _db
        .collection('products')
        .document('fresh')
        .collection('categories')
        .document('vegetables')
        .collection('items')
        .limit(16)
        .getDocuments();
    for (var d in data.documents) {
      if (checkProductStatus(d)) {
        fruitsAndVegetables.add(ProductModel(
          name: d.data['name'],
          imageUrl: d.data['imageUrl'],
          price: d.data['price'],
          weight: d.data['weight'],
          quantity: 0,
          sGST: d.data['SGST'].toDouble(),
          iGST: d.data['IGST'].toDouble(),
          cGST: d.data['CGST'].toDouble(),
          hSN: d.data['HSN/SAC'],
          sKU: d.data['SKU'],
        ));
      }
    }

    var fruits = await _db
        .collection('products')
        .document('fresh')
        .collection('categories')
        .document('fruits')
        .collection('items')
        .limit(16)
        .getDocuments();
    for (var d in fruits.documents) {
      if (checkProductStatus(d)) {
        fruitsAndVegetables.add(ProductModel(
          name: d.data['name'],
          imageUrl: d.data['imageUrl'],
          price: d.data['price'],
          weight: d.data['weight'],
          quantity: 0,
          sGST: d.data['SGST'].toDouble(),
          iGST: d.data['IGST'].toDouble(),
          cGST: d.data['CGST'].toDouble(),
          hSN: d.data['HSN/SAC'],
          sKU: d.data['SKU'],
        ));
      }
    }
    fruitsAndVegetables.shuffle();
    fruitsAndVegetables.removeRange(11, fruitsAndVegetables.length - 1);
    print("FRUITS AND VEG ${fruitsAndVegetables.length}");
    notifyListeners();
  }

  Future<void> getProductNames() async {
    productNames.clear();
    var cat = await _db
        .collection('products')
        .document('fresh')
        .collection('categories')
        .getDocuments();
    for (var d in cat.documents) {
      var data = await _db
          .collection('products')
          .document('fresh')
          .collection('categories')
          .document(d.documentID)
          .collection('items')
          .getDocuments();
      for (var d in data.documents) {
        if (checkProductStatus(d)) {
          productNames.add(d.data['name']);
        }
      }
    }
//    var data = await _db.collection('products').document('fresh').collection('categories').document('fruits').collection('items').getDocuments();
//    for (var d in data.documents) {
//      if (checkProductStatus(d)) {
//        productNames.add(d.data['name']);
//      }
//    }
//    var item = await _db.collection('products').document('fresh').collection('categories').document('vegetables').collection('items').getDocuments();
//    for (var i in item.documents) {
//      if (checkProductStatus(i)) {
//        productNames.add(i.data['name']);
//      }
//    }
    notifyListeners();
  }

  Future<void> getFeaturedProducts() async {
    var data = await _db.collection('featured').getDocuments();
    for (var d in data.documents) {
      if (checkProductStatus(d)) {
        featuredProductList.add(ProductModel(
          name: d.data['name'],
          price: d.data['price'],
          description: d.data['description'],
          weight: d.data['weight'],
          imageUrl: d.data['imageUrl'],
          sGST: d.data['SGST'].toDouble(),
          iGST: d.data['IGST'].toDouble(),
          cGST: d.data['CGST'].toDouble(),
          hSN: d.data['HSN/SAC'],
          sKU: d.data['SKU'],
          quantity: 0,
        ));
      }
    }
    notifyListeners();
  }

  Future<void> getProducts() async {
    productList.clear();
    print('cleared ' + productList.length.toString());
    print(selectedCategoryName);
    toggleLoadProducts();
    var data = await _db
        .collection('products')
        .document('fresh')
        .collection('categories')
        .document(selectedCategoryName)
        .collection('items')
        .getDocuments();
    for (var d in data.documents) {
      if (checkProductStatus(d)) {
        productList.add(ProductModel(
          name: d.data['name'],
          imageUrl: d.data['imageUrl'],
          price: d.data['price'],
          weight: d.data['weight'],
          quantity: 0,
          sGST: d.data['SGST'].toDouble(),
          iGST: d.data['IGST'].toDouble(),
          cGST: d.data['CGST'].toDouble(),
          hSN: d.data['HSN/SAC'],
          sKU: d.data['SKU'],
        ));
      }
    }
    print(productList.length);
    toggleLoadProducts();
    notifyListeners();
  }

  Future<void> getVegetablesProducts() async {
    vegetablesProductList.clear();
    var data = await _db
        .collection('products')
        .document('fresh')
        .collection('categories')
        .document('vegetables')
        .collection('items')
        .getDocuments();
    for (var d in data.documents) {
      if (checkProductStatus(d)) {
        vegetablesProductList.add(ProductModel(
          name: d.data['name'],
          imageUrl: d.data['imageUrl'],
          price: d.data['price'],
          weight: d.data['weight'],
          quantity: 0,
          sGST: d.data['SGST'].toDouble(),
          iGST: d.data['IGST'].toDouble(),
          cGST: d.data['CGST'].toDouble(),
          hSN: d.data['HSN/SAC'],
          sKU: d.data['SKU'],
        ));
      }
    }
    notifyListeners();
  }

  Future<void> getCat1Products() async {
    cat1ProductList.clear();
    var data = await _db
        .collection('products')
        .document('fresh')
        .collection('categories')
        .document('z_cat1')
        .collection('items')
        .getDocuments();
    for (var d in data.documents) {
      if (checkProductStatus(d)) {
        cat1ProductList.add(ProductModel(
          name: d.data['name'],
          imageUrl: d.data['imageUrl'],
          price: d.data['price'],
          weight: d.data['weight'],
          quantity: 0,
          sGST: d.data['SGST'].toDouble(),
          iGST: d.data['IGST'].toDouble(),
          cGST: d.data['CGST'].toDouble(),
          hSN: d.data['HSN/SAC'],
          sKU: d.data['SKU'],
        ));
      }
    }
    notifyListeners();
  }

  Future<void> getCat2Products() async {
    cat2ProductList.clear();
    var data = await _db
        .collection('products')
        .document('fresh')
        .collection('categories')
        .document('z_cat2')
        .collection('items')
        .getDocuments();
    for (var d in data.documents) {
      if (checkProductStatus(d)) {
        cat2ProductList.add(ProductModel(
          name: d.data['name'],
          imageUrl: d.data['imageUrl'],
          price: d.data['price'],
          weight: d.data['weight'],
          quantity: 0,
          sGST: d.data['SGST'].toDouble(),
          iGST: d.data['IGST'].toDouble(),
          cGST: d.data['CGST'].toDouble(),
          hSN: d.data['HSN/SAC'],
          sKU: d.data['SKU'],
        ));
      }
    }
    notifyListeners();
  }

  Future<void> getCat3Products() async {
    cat3ProductList.clear();
    var data = await _db
        .collection('products')
        .document('fresh')
        .collection('categories')
        .document('z_cat3')
        .collection('items')
        .getDocuments();
    for (var d in data.documents) {
      if (checkProductStatus(d)) {
        cat3ProductList.add(ProductModel(
          name: d.data['name'],
          imageUrl: d.data['imageUrl'],
          price: d.data['price'],
          weight: d.data['weight'],
          quantity: 0,
          sGST: d.data['SGST'].toDouble(),
          iGST: d.data['IGST'].toDouble(),
          cGST: d.data['CGST'].toDouble(),
          hSN: d.data['HSN/SAC'],
          sKU: d.data['SKU'],
        ));
      }
    }
    notifyListeners();
  }

  Future<void> getCat4Products() async {
    cat4ProductList.clear();
    var data = await _db
        .collection('products')
        .document('fresh')
        .collection('categories')
        .document('z_cat4')
        .collection('items')
        .getDocuments();
    for (var d in data.documents) {
      if (checkProductStatus(d)) {
        cat4ProductList.add(ProductModel(
          name: d.data['name'],
          imageUrl: d.data['imageUrl'],
          price: d.data['price'],
          weight: d.data['weight'],
          quantity: 0,
          sGST: d.data['SGST'].toDouble(),
          iGST: d.data['IGST'].toDouble(),
          cGST: d.data['CGST'].toDouble(),
          hSN: d.data['HSN/SAC'],
          sKU: d.data['SKU'],
        ));
      }
    }
    notifyListeners();
  }

  Future<void> getFruitsProducts() async {
    fruitsProductList.clear();
    var data = await _db
        .collection('products')
        .document('fresh')
        .collection('categories')
        .document('fruits')
        .collection('items')
        .getDocuments();
    for (var d in data.documents) {
      if (checkProductStatus(d)) {
        fruitsProductList.add(ProductModel(
          name: d.data['name'],
          imageUrl: d.data['imageUrl'],
          price: d.data['price'],
          weight: d.data['weight'],
          quantity: 0,
          sGST: d.data['SGST'].toDouble(),
          iGST: d.data['IGST'].toDouble(),
          cGST: d.data['CGST'].toDouble(),
          hSN: d.data['HSN/SAC'],
          sKU: d.data['SKU'],
        ));
      }
    }
    notifyListeners();
  }
}
