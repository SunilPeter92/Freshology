// class UserModel {
//   String userCountry;
//   String userPhoneNumber;
//   String userName;
//   String userEmail;
//   String userCity;
//   String userPinCode;
//   String userState;
//   String userArea;
//   String userHouseNo;
//   int userBalance;
//   int userId;
//   int userOrderNumber;
//   bool auth;

//   UserModel(
//       {this.userCountry,
//       this.userPhoneNumber,
//       this.userCity,
//       this.userHouseNo,
//       this.userState,
//       this.userEmail,
//       this.userName,
//       this.userPinCode,
//       this.userArea,
//       this.userBalance,
//       this.userId,
//       this.userOrderNumber,
//       this.auth});

//   UserModel.fromJSON(Map<String, dynamic> jsonMap['user_data']) {
//     try {
//       userCountry = jsonMap['user_data']['country'].toString();
//       userPhoneNumber = jsonMap['user_data']['phone_no'].toString();
//       userCity = jsonMap['user_data']['city'].toString();
//       userHouseNo = jsonMap['user_data']['address'].toString();
//       userId = jsonMap['user_data']['id'];
//       userState = jsonMap['user_data']['state'].toString();
//       userEmail = (jsonMap['user_data']['email'] == null || jsonMap['user_data']['email'] == '')
//           ? null
//           : jsonMap['user_data']['email'];
//       userName = jsonMap['user_data']['name'].toString();
//       userPinCode = jsonMap['user_data']['pinecode'].toString();
//       userArea = jsonMap['user_data']['area'].toString();
//       userBalance = (jsonMap['user_data']['balance'] == null || jsonMap['user_data']['balance'] == '')
//           ? null
//           : int.parse(jsonMap['user_data']['balance']);
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   Map<String, dynamic> toMap() {
//     var userMap = new Map<String, dynamic>();
//     userMap["name"] = userName;
//     userMap["phone_no"] = userPhoneNumber;
//     userMap["city"] = userCity;
//     userMap["house_no"] = userHouseNo;
//     userMap["state"] = userState;
//     userMap["pinecode"] = userPinCode.toString();
//     userMap["balance"] = "0";
//     userMap["area"] = userArea;
//     userMap["email"] = userEmail;
//     userMap["total_orders"] = "0";
//     return userMap;
//   }
// }
import 'package:freshology/models/Address.dart';
import 'package:freshology/screens/myAdresses.dart';

import '../helpers/custom_trace.dart';
import '../models/media.dart';

class User {
  String id;
  String name;
  String email;
  String apiToken;
  String deviceToken;
  String phone;
  String address;
  String bio;
  Media image;
  String countryId;
  String countryName;
  String stateId;
  String stateName;
  String cityId;
  String cityName;
  String areaId;
  String areaName;
  String houseNo;
  String pinCode;
  String status;
  // used for indicate if client logged in or not
  List<Address> addresses;
  bool auth;

//  String role;

  User({
    this.id,
    this.name,
    this.email,
    this.apiToken,
    this.deviceToken,
    this.phone,
    this.address,
    this.bio,
    this.image,
    this.countryId,
    this.countryName,
    this.stateId,
    this.stateName,
    this.cityId,
    this.cityName,
    this.areaId,
    this.areaName,
    this.houseNo,
    this.pinCode,
    this.status,
    this.addresses,
  });

  User.fromJSON(Map<String, dynamic> jsonMap) {
    print(jsonMap.toString());
    try {
      id = jsonMap['user_data']['id'].toString();
      name = jsonMap['user_data']['name'] != null
          ? jsonMap['user_data']['name']
          : '';
      email = jsonMap['user_data']['email'] != null
          ? jsonMap['user_data']['email']
          : '';
      apiToken = jsonMap['user_data']['api_token'];
      deviceToken = jsonMap['user_data']['device_token'];
      countryName = jsonMap['user_data']['country'];
      countryId = jsonMap['user_data']['country_id'];
      stateId = jsonMap['user_data']['state_id'];
      stateName = jsonMap['user_data']['state'];
      cityId = jsonMap['user_data']['city_id'];
      cityName = jsonMap['user_data']['city'];
      areaId = jsonMap['user_data']['area_id'];
      areaName = jsonMap['user_data']['area'];
      houseNo = jsonMap['user_data']['house_no'];
      pinCode = jsonMap['user_data']['pinecode'];
      status = jsonMap['user_data']['status'];
      addresses = [];
      try {
        phone = jsonMap['user_data']['phone_no'];
      } catch (e) {
        phone = "";
      }

      // image = jsonMap['user_data']['media'] != null && (jsonMap['user_data']['media'] as List).length > 0
      //     ? Media.fromJSON(jsonMap['user_data']['media'][0])
      //     : new Media();
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  List<Address> setAddress(jsonMap) {
    List<Address> _addresses = [];
    for (int i = 0; i < jsonMap['user_address'].length; i++) {
      _addresses.add(
        Address.fromJson(
          jsonMap['user_address'][i],
        ),
      );
    }
    return _addresses;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();

    map["email"] = (email == null || email == '') ? "sample@temp.com" : email;
    map["name"] = name;
    map["api_token"] = apiToken;
    map["device_token"] = deviceToken;
    map["phone_no"] = phone;
    map["address"] = address;
    map["bio"] = bio;
    map["media"] = image?.toMap();
    map["country"] = countryName;
    map["country_id"] = countryId;
    map["state_id"] = countryId;
    map["state"] = stateName;
    map["city_id"] = cityId;
    map["city"] = cityName;
    map["area_id"] = areaId;
    map["area"] = areaName;
    map['house_no'] = houseNo;
    map['pinecode'] = pinCode;

    return map;
  }

  @override
  String toString() {
    var map = this.toMap();
    map["auth"] = this.auth;
    return map.toString();
  }

  bool profileCompleted() {
    return areaId != null && areaId != '' && phone != null && phone != '';
  }
}
