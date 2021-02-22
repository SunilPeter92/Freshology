import 'package:freshology/constants/Helper.dart';
import 'package:freshology/constants/configurations.dart';
import 'package:freshology/models/product.dart';
import 'package:freshology/repositories/category_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Product> getSingleProductId(String id) async {
  final url = "${baseURL}single_product/${id}";
  try {
    var response = await http.get(url, headers: header);
    if (response.statusCode == 201 || response.statusCode == 200) {
      var data = Helper.getData(json.decode(response.body));
      Product _product = Product.fromJson(data[0]);
      await getMainCategory();
      return _product;
    }
  } catch (e) {
    print("ERROR! ${e}");
  }
}

Future<List<Product>> getSubCategoryProducts(String id) async {
  List<Product> products = [];
  final url = "${baseURL}get_product_by_cate/${id}";
  try {
    var response = await http.get(url, headers: header);
    print("${id} - GET PRODUCTS JSON: ${response.body}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      var data = json.decode(response.body);
      print("JSON DATA: ${data[0]['data']}");
      try {
        for (int i = 0; i < data.length; i++) {
          Product _product = Product();
          data[i]['data'].putIfAbsent("variations", () => <Variation>[]);
          List<Variation> _variations = [];
          _product = Product.fromJson(data[i]["data"]);
          for (int j = 0; j < data[i]["variations"].length; j++) {
            _variations.add(Variation.fromJson(data[i]["variations"][j]));
            print("VARIATIONS: ${j}");
          }
          _product.variations = _variations;
          products.add(_product);
        }
      } catch (e) {
        print("ERROR IN PARSING PRODUCTS: ${e}");
        return <Product>[];
      }

      // try {
      //   for (var product in data) {
      //     products.add(Product.fromJson(product));
      //   }
      //   return products;
      // } catch (e) {
      //   return null;
      // }
    }
    return products;
  } catch (e) {
    print("ERROR! ${e}");
    return null;
  }
}
