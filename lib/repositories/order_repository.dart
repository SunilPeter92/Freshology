import 'dart:convert';
import 'dart:io';
import 'package:freshology/constants/configurations.dart';
import 'package:freshology/helpers/helper.dart';
import 'package:freshology/models/order.dart';
import 'package:freshology/models/order_status.dart';
import 'package:freshology/models/payment.dart';
import 'package:freshology/models/product.dart';
import 'package:freshology/models/userModel.dart';
import 'package:freshology/repositories/user_repository.dart';
import 'package:http/http.dart' as http;

Future<Stream<Product>> getOrders() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${baseURL}orders?${_apiToken}with=user;foodOrders;foodOrders.food;orderStatus&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=id&sortedBy=desc';
  print("getOrders URL: ${url}");
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

Future<Stream<Product>> getOrder(orderId) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${baseURL}orders/$orderId?${_apiToken}with=user;foodOrders;foodOrders.food;orderStatus';
  print("GET SINGLE ORDER URL : ${url}");
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .map((data) {
    return Product.fromJson(data);
  });
}

// Future<Stream<Reservation>> getReservations() async {
//   User _user = await getCurrentUser();
//   final String _apiToken = 'api_token=${_user.apiToken}&';
//   // final String url =
//   //     '${GlobalConfiguration().getString('api_base_url')}orders/$orderId?${_apiToken}with=user;foodOrders;foodOrders.food;orderStatus';
//   final String url =
//       "http://newfoodish.autosandtools.com/public/api/reservation_status/${_user.id}";
//   print("GET RESERVATIONS URL : ${url}");
//   final client = new http.Client();
//   final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

//   return streamedRest.stream
//       .transform(utf8.decoder)
//       .transform(json.decoder)
//       .map((data) => Helper.getData(data))
//       .map((data) {
//     Reservation res = Reservation.fromJSON(data);

//     print("RESERVATION OBJ ${res.email}");
//     return res;
//   });
// }

Future<Stream<Product>> getRecentOrders() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${baseURL}orders?${_apiToken}with=user;foodOrders;foodOrders.food;orderStatus&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=updated_at&sortedBy=desc&limit=3';
  print("GET RECENT ORDERS URL : ${url}");
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

Future<Stream<OrderStatus>> getOrderStatus() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${baseURL}order_statuses?$_apiToken';
  print("GET ORDER STATUS URL : ${url}");

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return OrderStatus.fromJSON(data);
  });
}

// Future<Stream<Reservation>> getReservationStatus() async {
//   User _user = await getCurrentUser();
//   final String _apiToken = 'api_token=${_user.apiToken}';
//   // final String url =
//   //     '${GlobalConfiguration().gefString('api_base_url')}order_statuses?$_apiToken';
//   final String url =
//       "http://newfoodish.autosandtools.com/public/api/reservation_status/25";
//   final client = new http.Client();
//   final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

//   return streamedRest.stream
//       .transform(utf8.decoder)
//       .transform(json.decoder)
//       .map((data) => getData(data))
//       .expand((data) => (data as List))
//       .map((data) {
//     print("EXPANDED DATA: $data");
//     return Reservation.fromJSON(data);
//   });
// }

getData(Map<String, dynamic> data) {
  return data['success'] ?? [];
}

Future<Product> addOrder(Order order, Payment payment) async {
  User _user = await getCurrentUser();
  // CreditCard _creditCard = await getCreditCard();
  order.user = _user;
  order.payment = payment;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${baseURL}orders?$_apiToken';
  print("orderAdd URL: ${url}");
  final client = new http.Client();
  Map params = order.toMap();
  // params.addAll(_creditCard.toMap());
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(params),
  );
  return Product.fromJson(json.decode(response.body)['data']);
}
