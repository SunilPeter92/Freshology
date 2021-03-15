import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freshology/constants/Helper.dart';
import 'package:freshology/constants/configurations.dart';
import 'package:freshology/models/Address.dart';
import 'package:freshology/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../repositories/appListenables.dart';

Future<User> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.clear();
  if (prefs.containsKey('current_user')) {
    currentUser.value =
        User.fromJSON(json.decode(await prefs.get('current_user')));
  } else {}
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  currentUser.notifyListeners();
  return currentUser.value;
}

Future<User> update(User user) async {
  final String _apiToken = 'api_token=${currentUser.value.apiToken}';
  final String url = '${baseURL}users/${currentUser.value.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  setCurrentUser(response.body);
  currentUser.value = User.fromJSON(json.decode(response.body)['data']);
  return currentUser.value;
}

void setCurrentUser(jsonString) async {
  try {
    if (json.decode(jsonString)['user_data'] != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'current_user', json.encode(json.decode(jsonString)));
    }
  } catch (e) {
    print("ERROR! (setCurrentUser): ${e.toString()}");
    throw new Exception(e);
  }
}

Future<User> register(User user) async {
  final String url = '${baseURL}user_register';
  print("REGISTER URL: ${url}");
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  print("RESPONSE: ${response.body.toString()}");
  if (response.statusCode == 201 ||
      response.statusCode == 202 ||
      response.statusCode == 200) {
    if (json.decode(response.body)['status'] == "Code Send On Your Number") {
      Map<String, dynamic> userObj = json.decode(response.body)['data'];

      // setCurrentUser(json.encode(json.decode(response.body)));
      // print("REGISTER BODY: ${response.body}");
      User _user = User(
        apiToken: userObj['api_token'],
        id: userObj['id'].toString(),
        phone: userObj['phone_no'],
      );
      currentUser.value = _user;
    }
  }
  return currentUser.value;
}

Future<void> _register(User user) async {
  final String url = "${baseURL}user_register";
  try {
    final response = await http.post(url, body: user.toMap());
    var body = json.decode(response.body);
    if (response.statusCode == 200) {
      if (body['data'] == "code sent") {
        return "code sent";
      } else if (body['data'] == "user already exists") {
        return "User already exisits";
      } else {
        return "Something went wrong";
      }
    }
    return "Something went wrong";
  } catch (e) {
    print("Error ! (register) ${e.toString()}");
    return "Something went wrong";
  }
}

login(String phone) async {
  final String url = '${baseURL}login';
  print("REGISTER URL: ${url}");
  Map<String, dynamic> map = {"phone_no": phone};
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(map),
  );
  print("RESPONSE: ${response.body.toString()}");
  if (response.statusCode == 201 ||
      response.statusCode == 202 ||
      response.statusCode == 200) {
    if (json.decode(response.body)['status'] == "successfully" || json.decode(response.body)['status'] == "Verify your account") {
      Map<String, dynamic> userObj = json.decode(response.body)['data'];

      // setCurrentUser(json.encode(json.decode(response.body)));
      // print("REGISTER BODY: ${response.body}");
      User _user = User(
        apiToken: userObj['api_token'],
        id: userObj['id'].toString(),
        phone: userObj['phone_no'],
      );
      currentUser.value = _user;
    }
  }
  return currentUser.value;
}

verifyRegisterOTP(String code, String phone, String userId) async {
  Map<String, dynamic> map = {
    "code": code,
    "phone": phone,
    "user_id": userId,
  };
  print("MAP: ${map}");
  final client = new http.Client();
  final String url = "${baseURL}verify_code";
  print(url);
  try {
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(map),
    );
    var body = json.decode(response.body);
    print(body);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      if (body['status'] == "code not matched") {
        return "Invalid code entered";
      }
      if (body['user_data']['id'] != null) {
        setCurrentUser(response.body);
        currentUser.value = await getCurrentUser();
        return "success";
      }
    }
    return "Something went wrong";
  } catch (e) {
    print("ERROR ! (verifyRegisterOTP)  ${e.toString()}");
    return "Something went wrong";
  }
}

verifyLoginOTP(String code, String phone, String userId) async {
  Map<String, dynamic> map = {
    "code": code,
    "phone": phone,
    "user_id": userId,
  };
  print("MAP: ${map}");
  final client = new http.Client();
  final String url = "${baseURL}verify_login";
  print(url);
  try {
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(map),
    );
    var body = json.decode(response.body);
    print(body);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      if (body['status'] == "code not matched") {
        return "Invalid code entered";
      }
      if (body['user_data']['id'] != null) {
        setCurrentUser(response.body);
        currentUser.value = await getCurrentUser();
        return "success";
      }
    }
    return "Something went wrong";
  } catch (e) {
    print(e);
    print("ERROR ! (verifyRegisterOTP)  ");
    return "Something went wrong";
  }
}

Future<Stream<Address>> getAddresses() async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url = '${baseURL}get_user_address/${_user.id}';
  print("GET USER ADDRESSES: ${url}");
  print("URL: ${url}");
  print(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Address.fromJson(data);
  });
}

addAddress(Address address) async {
  User _user = currentUser.value;
  address.userId = _user.id;
  final String url = '${baseURL}add_user_address';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(address.toJson()),
  );
  if (json.decode(response.body)['status'] == "success") {
    return "success";
  } else {
    return "failure";
  }
}

Future<String> updateAddress(Address address) async {
  User _user = currentUser.value;
  address.userId = _user.id;
  final String url = '${baseURL}edit_user_address';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(address.toJson()),
  );
  print("DECODED JSON ${response.body}");
  if (json.decode(response.body)['status'] == "success") {
    return "success";
  } else {
    return "failure";
  }
  // return Address.fromJson(json.decode(response.body)['data']);
}

Future<Address> removeDeliveryAddress(Address address) async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${baseURL}delivery_addresses/${address.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.delete(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  return Address.fromJson(json.decode(response.body)['data']);
}

Future<void> logout() async {
  currentUser.value = new User();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_user');
}
// verifyLoginOTP(String code, String phone) async {
//   var map = {
//     "code": code,
//     "phone_no": phone,
//   };
//   print(map);
//   final String url = "${baseURL}verify_login";
//   try {
//     final response = await http.post(url, body: map);
//     print("RESPONSE: ${response.body}");
//     Map<String, dynamic> body = json.decode(response.body);
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       if (body['data'] == "invaild code") {
//         return "Invalid code entered";
//       } else if (body['data']['id'].toString().isNotEmpty) {
//         setCurrentUser(response.body);
//         currentUser.value = User.fromJSON(body['data']);
//         print("DATA : ${body['data'].runtimeType}");
//         print("USER ID : ${currentUser.value.email}");
//         return currentUser.value;
//       } else {
//         return "Something went wrong";
//       }
//     }
//     return "Something went wrong";
//   } catch (e) {
//     print("ERROR ! (verifyLoginOTP)  ${e.toString()}");

//     return "Something went wrong";
//   }
// }
