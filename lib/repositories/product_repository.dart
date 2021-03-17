import 'package:freshology/constants/Helper.dart';
import 'package:freshology/constants/configurations.dart';
import 'package:freshology/helpers/custom_trace.dart';
import 'package:freshology/models/product.dart';
import 'package:freshology/models/userModel.dart';
import 'package:freshology/repositories/category_repository.dart';
import 'package:freshology/repositories/user_repository.dart';
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

Future<Stream<Product>> getFoodsByCategory(categoryId) async {
  final String url =
      '${baseURL}foods?with=restaurant;extras&search=category_id:$categoryId&searchFields=category_id:=';
  print("PRODUCTS BY CATEGORY: ${url}");
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Product.fromJson(data);
  });
}

Future<Stream<Product>> getProductById(String productId) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${baseURL}foods/$productId?${_apiToken}with=nutrition;restaurant;category;extras;foodReviews;foodReviews.user';
  print("GET FOOD BY: ${url}");
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .map((data) => Product.fromJson(data));
}

Future<Stream<Product>> getTrendingProducts() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${baseURL}foods?${_apiToken}with=restaurant;category;extras;foodReviews;foodReviews.user&limit=6';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Product.fromJson(data);
  });
}


Future<Stream<Product>> searchProducts(String search) async {
  Uri uri = Uri.parse(
  '${baseURL}foods');
  Map<String, dynamic> _queryParams = {};
  _queryParams['search'] = 'name:$search;description:$search';
  _queryParams['searchFields'] = 'name:like;description:like';
  _queryParams['limit'] = '5';
  // if (!address.isUnknown()) {
  //   _queryParams['myLon'] = address.longitude.toString();
  //   _queryParams['myLat'] = address.latitude.toString();
  //   _queryParams['areaLon'] = address.longitude.toString();
  //   _queryParams['areaLat'] = address.latitude.toString();
  // }
  uri = uri.replace(queryParameters: _queryParams);
  print('URI SEARCH : ${uri.toString()}');
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Product.fromJson(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Product.fromJson({}));
  }
}
// Future<List<Product>> getSubCategoryProducts(String id) async {
//   List<Product> products = [];
//   final url = "${baseURL}get_product_by_cate/${id}";
//   try {
//     var response = await http.get(url, headers: header);
//     print("${id} - GET PRODUCTS JSON: ${response.body}");
//     if (response.statusCode == 201 || response.statusCode == 200) {
//       var data = json.decode(response.body);
//       print("JSON DATA: ${data[0]['data']}");
//       try {
//         for (int i = 0; i < data.length; i++) {
//           Product _product = Product();
//           data[i]['data'].putIfAbsent("variations", () => <Variation>[]);
//           List<Variation> _variations = [];
//           _product = Product.fromJson(data[i]["data"]);
//           for (int j = 0; j < data[i]["variations"].length; j++) {
//             _variations.add(Variation.fromJson(data[i]["variations"][j]));
//             print("VARIATIONS: ${j}");
//           }
//           _product.variations = _variations;
//           products.add(_product);
//         }
//       } catch (e) {
//         print("ERROR IN PARSING PRODUCTS: ${e}");
//         return <Product>[];
//       }

//       // try {
//       //   for (var product in data) {
//       //     products.add(Product.fromJson(product));
//       //   }
//       //   return products;
//       // } catch (e) {
//       //   return null;
//       // }
//     }
//     return products;
//   } catch (e) {
//     print("ERROR! ${e}");
//     return null;
//   }
// }
