import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freshology/constants/configurations.dart';
import 'package:freshology/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

ValueNotifier<UserModel> currentUser = new ValueNotifier(UserModel());

Future<UserModel> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.clear();
  if (prefs.containsKey('current_user')) {
    currentUser.value =
        UserModel.fromJSON(json.decode(await prefs.get('current_user')));
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
          'current_user', json.encode(json.decode(jsonString)['data']));
    }
  } catch (e) {
    print("ERROR! (setCurrentUser): ${e.toString()}");
    throw new Exception(e);
  }
}

Future<void> register(UserModel user) async {
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

login(UserModel user) async {
  // final String url = 'http://a018.autosandtools.com/api/user_login';
  final String url = '${baseURL}user_login';
  Map<String, dynamic> param = {"phone_no": user.userPhoneNumber};
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

verifyRegisterOTP(String code, String phone) async {
  var map = {
    "code": code,
    "phone_no": phone,
  };
  final String url = "${baseURL}/number_verified";
  try {
    final response = await http.post(url, body: map);
    var body = json.decode(response.body);
    if (response.statusCode == 200) {
      if (body['data'] == "invaild code") {
        return "Invalid code entered";
      } else {
        return "Something went wrong";
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
        currentUser.value = UserModel.fromJSON(body['data']);
        print("DATA : ${body['data'].runtimeType}");
        print("USER ID : ${currentUser.value.userEmail}");
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
