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

//   UserModel.fromJSON(Map<String, dynamic> jsonMap) {
//     try {
//       userCountry = jsonMap['country'].toString();
//       userPhoneNumber = jsonMap['phone_no'].toString();
//       userCity = jsonMap['city'].toString();
//       userHouseNo = jsonMap['address'].toString();
//       userId = jsonMap['id'];
//       userState = jsonMap['state'].toString();
//       userEmail = (jsonMap['email'] == null || jsonMap['email'] == '')
//           ? null
//           : jsonMap['email'];
//       userName = jsonMap['name'].toString();
//       userPinCode = jsonMap['pinecode'].toString();
//       userArea = jsonMap['area'].toString();
//       userBalance = (jsonMap['balance'] == null || jsonMap['balance'] == '')
//           ? null
//           : int.parse(jsonMap['balance']);
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
  });

  User.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'] != null ? jsonMap['name'] : '';
      email = jsonMap['email'] != null ? jsonMap['email'] : '';
      apiToken = jsonMap['api_token'];
      deviceToken = jsonMap['device_token'];
      // countryName = jsonMap['country'];
      // countryId = jsonMap['country_id'];
      // stateId = jsonMap['state_id'];
      // stateName = jsonMap['state'];
      // cityId = jsonMap['city_id'];
      // cityName = jsonMap['city'];
      // areaId = jsonMap['area_id'];
      // areaName = jsonMap['area'];
      // houseNo = jsonMap['house_no'];
      // pinCode = jsonMap['pinecode'];
      status = jsonMap['status'];
      try {
        phone = jsonMap['phone_no'];
      } catch (e) {
        phone = "";
      }

      // image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
      //     ? Media.fromJSON(jsonMap['media'][0])
      //     : new Media();
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
    }
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
