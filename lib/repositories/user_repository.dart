import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freshology/constants/Helper.dart';
import 'package:freshology/constants/configurations.dart';
import 'package:freshology/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

ValueNotifier<User> currentUser = new ValueNotifier(User());

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

void setCurrentUser(jsonString) async {
  try {
    if (json.decode(jsonString)['data'] != null) {
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
      userObj.putIfAbsent("country", () => user.countryName);
      userObj.putIfAbsent("country_id", () => user.countryId);
      userObj.putIfAbsent("state", () => user.stateName);
      userObj.putIfAbsent("state_id", () => user.stateId);
      userObj.putIfAbsent("city", () => user.cityName);
      userObj.putIfAbsent("city_id", () => user.cityId);
      userObj.putIfAbsent("area", () => user.areaName);
      userObj.putIfAbsent("area_id", () => user.areaId);
      userObj.putIfAbsent("house_no", () => user.houseNo);
      print("USER OBJ : ${userObj}");
      setCurrentUser(json.encode(userObj));
      print("REGISTER BODY: ${response.body}");
      currentUser.value = User.fromJSON(json.decode(response.body)['data']);
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

login(User user) async {
  // final String url = 'http://a018.autosandtools.com/api/user_login';
  final String url = '${baseURL}user_login';
  Map<String, dynamic> param = {"phone_no": user.phone};
  try {
    final response = await http.post(url, body: param);
    print("STATUS CODE uploaded ${response.statusCode}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      var body = json.decode(response.body);
      if (body['data'] == "code sent") {
        return "code sent";
      } else if (body['data'] == "user does not exists") {
        return "User not found";
      }
    }
    return "Something went wrong";
  } catch (e) {
    print("ERROR ! (login)  ${e.toString()}");
    return "Something went wrong";
  }
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
        return "success";
      }
    }
    return "Something went wrong";
  } catch (e) {
    print("ERROR ! (verifyRegisterOTP)  ${e.toString()}");
    return "Something went wrong";
  }
}

verifyLoginOTP(String code, String phone) async {
  var map = {
    "code": code,
    "phone_no": phone,
  };
  print(map);
  final String url = "${baseURL}login_verifed";
  try {
    final response = await http.post(url, body: map);
    print("RESPONSE: ${response.body}");
    Map<String, dynamic> body = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (body['data'] == "invaild code") {
        return "Invalid code entered";
      } else if (body['data']['id'].toString().isNotEmpty) {
        setCurrentUser(response.body);
        currentUser.value = User.fromJSON(body['data']);
        print("DATA : ${body['data'].runtimeType}");
        print("USER ID : ${currentUser.value.email}");
        return currentUser.value;
      } else {
        return "Something went wrong";
      }
    }
    return "Something went wrong";
  } catch (e) {
    print("ERROR ! (verifyLoginOTP)  ${e.toString()}");

    return "Something went wrong";
  }
}
