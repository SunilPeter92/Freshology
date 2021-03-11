import 'dart:convert';
import 'dart:io';

import 'package:freshology/constants/configurations.dart';
import 'package:freshology/helpers/helper.dart';
import 'package:freshology/models/favorite.dart';
import 'package:freshology/models/userModel.dart';
import 'package:freshology/repositories/user_repository.dart' as userRepo;
import 'package:freshology/repositories/appListenables.dart';
import 'package:http/http.dart' as http;

Future<Stream<Favorite>> isFavoriteFood(String foodId) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${baseURL}favorites/exist?${_apiToken}food_id=$foodId&user_id=${_user.id}';
  print("IS FAVOTITE URL: ${url}");
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getObjectData(data))
      .map((data) => Favorite.fromJSON(data));
}

Future<Stream<Favorite>> getFavorites() async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${baseURL}favorites?${_apiToken}with=food;user;extras&search=user_id:${_user.id}&searchFields=user_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) => Favorite.fromJSON(data));
}

Future<Favorite> addFavorite(Favorite favorite) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return new Favorite();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  favorite.userId = _user.id;
  final String url = '${baseURL}favorites?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(favorite.toMap()),
  );
  return Favorite.fromJSON(json.decode(response.body)['data']);
}

Future<Favorite> removeFavorite(Favorite favorite) async {
  User _user = currentUser.value;
  if (_user.apiToken == null) {
    return new Favorite();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${baseURL}favorites/${favorite.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.delete(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  return Favorite.fromJSON(json.decode(response.body)['data']);
}
