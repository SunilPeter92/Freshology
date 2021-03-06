import 'dart:convert';
import 'dart:io';

import 'package:freshology/constants/configurations.dart';
import 'package:freshology/controllers/cart_controller.dart';
import 'package:freshology/models/cart.dart';
import 'package:freshology/models/userModel.dart';
import '../helper/helper.dart';
import 'package:http/http.dart' as http;
// import '../repositories/user_repository.dart' as userRepo;
import '../repositories/appListenables.dart';

Future<Stream<Cart>> getCart() async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}&';

  final String url =
      '${baseURL}carts?${_apiToken}with=food;extras&search=user_id:${_user.id}&searchFields=user_id:=';
  print("CART: ${url}");
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Cart.fromJSON(data);
  });
}

Future<Stream<int>> getCartCount() async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${baseURL}carts/count?${_apiToken}search=user_id:${_user.id}&searchFields=user_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map(
        (data) => Helper.getIntData(data),
      );
}

Future<Cart> addCart(Cart cart, bool reset) async {
  print("CART : ${cart.toMap()}");
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return new Cart();
  }
  Map<String, dynamic> decodedJSON = {};
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String _resetParam = 'reset=${reset ? 1 : 0}';
  cart.userId = _user.id.toString();
  final String url = '${baseURL}carts?$_apiToken&$_resetParam';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(cart.toMap()),
  );
  try {
    decodedJSON = json.decode(response.body)['data'] as Map<String, dynamic>;
    // currentCart.value.add(Cart.fromJSON(decodedJSON));

    // print(
    //     "CART VALUE AND COUNT ${cartValue.value} | ${currentCart.value.length}");

  } on FormatException catch (e) {
    print("The provided string is not valid JSON addCart");
  }
  print("DECODED JSON ${decodedJSON.toString()}");
  return Cart.fromJSON(decodedJSON);
}
//Future<Cart> addCart(Cart cart, bool reset) async {
//  User _user = userRepo.currentUser;
//  final String _apiToken = 'api_token=${_user.apiToken}';
//  final String _resetParam = 'reset=${reset ? 1 : 0}';
//  cart.userId = _user.id;
//  final String url = '${GlobalConfiguration().getString('api_base_url')}carts?$_apiToken&$_resetParam';
//  final client = new http.Client();
//  final response = await client.post(
//    url,
//    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
//    body: json.encode(cart.toMap()),
//  );
//  print(response.body);
//  return Cart.fromJSON(json.decode(response.body)['data']);
//
//
//}

Future<Cart> updateCart(Cart cart) async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  cart.userId = _user.id;
  final String url = '${baseURL}carts/${cart.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.put(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(cart.toMap()),
  );
  return Cart.fromJSON(json.decode(response.body)['data']);
}

Future<Cart> removeCart(Cart cart) async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${baseURL}carts/${cart.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.delete(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  return Cart.fromJSON(json.decode(response.body)['data']);
}
