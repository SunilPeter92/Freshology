import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freshology/constants/configurations.dart';
import 'package:freshology/functions/otpVerify.dart';
import 'package:freshology/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  String userPhoneNumber;
  UserModel user;
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
  GlobalKey<ScaffoldState> scaffoldKey;
  UserModel newUser = UserModel(
    userPhoneNumber: "",
    userName: "",
    userHouseNo: "",
    userEmail: '',
    userPinCode: "",
    userState: "",
    userCity: "",
    userArea: '',
    userBalance: 0,
  );
  String userDocID;
  UserModel userDetail = UserModel(
    userPhoneNumber: "",
    userName: "",
    userHouseNo: "",
    userEmail: '',
    userPinCode: "",
    userState: "",
    userCity: "",
    userArea: '',
    userBalance: 0,
  );
  Firestore _fireStore = Firestore.instance;
  int userID;

  Future<void> getUserIDNumber() async {
    var data =
        await _fireStore.collection('general').document('user_number').get();
    userID = data.data['user_number'] + 1;
    notifyListeners();
  }

  detectAddressChange() {}

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
    final url = "${baseURL}get_cities/$id";
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

  otpVerification(String phone, String code, BuildContext context) async {
    final String url = "http://a018.autosandtools.com/api/number_verifed";
    Map<String, dynamic> param = {"code": code.toString(), "phone_no": phone};
    try {
      final response = await http.post(url, body: param);
      print("Request uploaded ${param})}");
      print("STATUS CODE uploaded ${response.statusCode}");
      var body = json.decode(response.body);
      if (response.statusCode == 202) {
        if (body['status'] == "verification code not match") {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Invalid code entered"),
          ));
        } else {
          Navigator.pushNamed(context, "home");
        }
      }
    } catch (e) {
      print("ERROR !!!!  ${e.toString()}");
      return null;
    }
  }

  Future _register() async {
    final String url = 'http://a018.autosandtools.com/api/user_register';

    Map<String, dynamic> param = {
      "name": newUser.userName,
      "phone_no": newUser.userPhoneNumber,
      "city": newUser.userCity,
      "house_no": newUser.userHouseNo,
      "state": newUser.userState,
      "pinecode": newUser.userPinCode.toString(),
      "balance": "0",
      "area": newUser.userArea,
      "email": newUser.userEmail,
      "total_orders": "0"
    };

    print("PARAM : ${param}");
    try {
      // final response = await client.post(
      //   url,
      //   // headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      //   body: json.encode(param),
      // );
      final response = await http.post(url, body: param);
      print("Request uploaded ${param})}");
      print("STATUS CODE uploaded ${response.statusCode}");
      var body = json.decode(response.body);
      return body['status'];
    } catch (e) {
      print("ERROR !!!!  ${e.toString()}");
      return null;
    }
  }

  Future<void> registerUser(BuildContext context) async {
    await getUserIDNumber();

    // final result = await _fireStore.collection('user').add({
    //   'userID': userID,
    //   'name': newUser.userName,
    //   'phone': newUser.userPhoneNumber,
    //   'city': newUser.userCity,
    //   'house_no': newUser.userHouseNo,
    //   'state': newUser.userState,
    //   'pincode': newUser.userPinCode,
    //   'balance': 0,
    //   'area': newUser.userArea,
    //   'email': newUser.userEmail,
    //   'total_orders': 0,
    // });
    try {
      var res = await _register();
      if (res == null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Something went worng'),
        ));
      } else if (res == "success") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpVerify(
                    phoneNo: newUser.userPhoneNumber,
                    isLogin: false,
                  )),
        );
      } else {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(res),
        ));
      }
    } catch (e) {
      print("Error!! ${e}");
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Something went worng'),
      ));
    }

    // await _fireStore
    //     .collection('general')
    //     .document('user_number')
    //     .updateData({'user_number': userID});
  }

  loginUser(BuildContext context) async {
    final String url = 'http://a018.autosandtools.com/api/user_login';
    print("PHONE NO: ${newUser.userPhoneNumber}");
    Map<String, dynamic> param = {
      "phone_no": newUser.userPhoneNumber,
    };
    try {
      // final response = await client.post(
      //   url,
      //   // headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      //   body: json.encode(param),
      // );
      final response = await http.post(url, body: param);
      print("STATUS CODE uploaded ${response.statusCode}");
      if (response.statusCode == 201) {
        var body = json.decode(response.body);
        if (body['status'] == "Login code send on your phone number") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpVerify(
                      phoneNo: newUser.userPhoneNumber,
                      isLogin: true,
                    )),
          );
        } else {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Something went worng'),
          ));
        }
      } else {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Something went worng'),
        ));
      }
    } catch (e) {
      print("ERROR !!!!  ${e.toString()}");
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Something went worng'),
      ));
      return null;
    }
  }

  Future<void> getUserDetail() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser _user = await _auth.currentUser();
    if (_user != null) {
      String userNum = _user.phoneNumber;
      var data = await _fireStore.collection('user').getDocuments();
      for (var d in data.documents) {
        if (d.data['phone'] == userNum) {
          userDocID = d.documentID;
          userDetail.userId = d.data['userID'];
          userDetail.userOrderNumber = d.data['total_orders'];
          userDetail.userEmail = d.data['email'];
          userDetail.userName = d.data['name'];
          userDetail.userPhoneNumber = d.data['phone'];
          userDetail.userCity = d.data['city'];
          userDetail.userHouseNo = d.data['house_no'];
          userDetail.userArea = d.data['area'];
          userDetail.userPinCode = d.data['pincode'];
          userDetail.userState = d.data['state'];
          userDetail.userBalance = d.data['balance'];
          print(userDetail.userId);
          print(userDetail.userOrderNumber);
          break;
        }
      }
    }
    notifyListeners();
  }
}
