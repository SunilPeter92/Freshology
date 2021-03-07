import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:freshology/constants/configurations.dart';
import 'package:freshology/functions/otpVerify.dart';
import 'package:freshology/models/route.dart';
import 'package:freshology/models/userModel.dart';
import 'package:freshology/repositories/appListenables.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:freshology/repositories/user_repository.dart' as repo;
import 'package:http/http.dart' as http;

class UserController extends ControllerMVC {
  User user = User();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String userPhoneNumber;
  List<Map<String, dynamic>> countryList = [];
  List<String> countryNameList = [];
  List<String> stateNameList = [];
  List<String> cityNameList = [];
  List<String> areaNameList = [];
  var selectedCountry;
  var selectedCity;
  var selectedState;
  var selectedArea;
  bool showState = false;
  bool showCity = false;
  bool showArea = false;
  List<Map<String, dynamic>> stateList = [];
  List<Map<String, dynamic>> cityList = [];
  List<Map<String, dynamic>> areaList = [];
  FirebaseMessaging _firebaseMessaging;

  UserController() {
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {
      print("DEVICE TOKEN: ${_deviceToken}");
      user.deviceToken = _deviceToken;
    });
  }

  void loginUser() async {
    print("USER: ${user.toMap()}");
    repo.login(user.phone).then((value) {
      if (value != null && value.apiToken != null) {
        // scaffoldKey.currentState.showSnackBar(SnackBar(
        //   content: Text('Welcome ${value.name} !'),
        // ));
        Navigator.of(context).pushReplacementNamed('otp',
            arguments: RouteArgument(param: user, id: "1"));
      } else {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('User already registered'),
        ));
      }
    });
  }
  // loginUser() async {
  //   var res = await repo.login(user);
  //   if (res == "code sent") {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => OtpVerify(
  //           routeArgument: RouteArgument(
  //             param: user,
  //             id: "0",
  //           ),
  //         ),
  //       ),
  //     );
  //   } else {
  //     scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(res)));
  //   }
  // }

  // verifyLogin({String code}) async {
  //   var res = await repo.verifyLoginOTP(code, user.phone);
  //   if (res.runtimeType != User) {
  //     scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(res)));
  //   } else {
  //     user = res;
  //     Navigator.pushNamed(context, 'home');
  //   }
  // }

  verifyLogin({
    String code,
  }) async {
    var res = await repo.verifyLoginOTP(code, user.phone, user.id);
    if (res == "success") {
      Navigator.pushNamed(context, 'home');
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(res)));
    }
  }

  verifyRegister({String code}) async {
    var res = await repo.verifyRegisterOTP(code, user.phone, user.id);
    if (res == "success") {
      Navigator.pushNamed(context, 'home');
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(res)));
    }
  }

  void onCountryChanged() async {
    showState = true;
    showCity = false;
    showArea = false;
    nameListNullSetter(false, true, true, true);
    getState(selectedCountry["id"].toString());
    notifyListeners();
  }

  void onStateChanged() async {
    showState = true;
    showCity = true;
    showArea = false;
    nameListNullSetter(false, false, true, true);
    getCity(selectedState['id'].toString());

    notifyListeners();
  }

  void onCityChanged() async {
    showState = true;
    showCity = true;
    showArea = true;
    nameListNullSetter(false, false, false, true);
    getArea(selectedCity['id'].toString());
    notifyListeners();
  }

  getCountry() async {
    notifyListeners();
    final url = "${baseURL}get_country";
    final response = await http.get(url);
    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      Map<String, dynamic> _data = json.decode(response.body);

      for (var countries in _data['data']) {
        countryList.add({"name": countries['name'], "id": countries['id']});
        countryNameList.add(countries['name']);
      }

      selectedCountry = _data["data"][0];
      notifyListeners();
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Something went wrong'),
      ));
    }
  }

  nameListNullSetter(country, state, city, area) {
    countryNameList = country ? [] : countryNameList;
    stateNameList = state ? [] : stateNameList;
    cityNameList = city ? [] : cityNameList;
    areaNameList = area ? [] : areaNameList;
    notifyListeners();
  }

  getState(String id) async {
    final url = "${baseURL}get_state/$id";
    print("STATE URL: ${url}");
    final response = await http.get(url);
    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      Map<String, dynamic> _data = json.decode(response.body);
      if (_data['data'].isEmpty) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content:
              Text("Sorry, we don't deliver in ${selectedCountry['name']}"),
        ));
        showState = false;
        showCity = false;
        showArea = false;
        notifyListeners();
      } else {
        for (var states in _data['data']) {
          stateList.add({"name": states['name'], "id": states['id']});
          stateNameList.add(states['name']);
        }
        selectedState = _data["data"][0];
        notifyListeners();
      }
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Something went wrong'),
      ));
    }
  }

  getCity(String id) async {
    notifyListeners();
    final url = "${baseURL}get_city/$id";
    print("City URL: ${url}");
    final response = await http.get(url);
    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      Map<String, dynamic> _data = json.decode(response.body);
      for (var city in _data['data']) {
        cityList.add({"name": city['name'], "id": city['id']});
        cityNameList.add(city['name']);
      }

      selectedCity = _data["data"][0];
      notifyListeners();

      print(response.body);
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Something went wrong'),
      ));
    }
  }

  getArea(String id) async {
    notifyListeners();
    final url = "${baseURL}get_area/$id";
    print("City URL: ${url}");
    final response = await http.get(url);
    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      Map<String, dynamic> _data = json.decode(response.body);
      for (var area in _data['data']) {
        areaList.add({
          "name": area['name'],
          "id": area['id'],
          "pincode": area['pincode']
        });
        areaNameList.add(area['name']);
      }
      selectedArea = _data["data"][0];
      notifyListeners();

      print(response.body);
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Something went wrong'),
      ));
    }
  }

  void registerUser() async {
    print("USER: ${user.toMap()}");
    repo.register(user).then((value) {
      if (value != null && value.apiToken != null) {
        // scaffoldKey.currentState.showSnackBar(SnackBar(
        //   content: Text('Welcome ${value.name} !'),
        // ));
        Navigator.of(context).pushReplacementNamed('otp',
            arguments: RouteArgument(param: user, id: "0"));
      } else {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('User already registered'),
        ));
      }
    });
  }
}
