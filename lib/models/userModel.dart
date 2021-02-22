class UserModel {
  String userCountry;
  String userPhoneNumber;
  String userName;
  String userEmail;
  String userCity;
  String userPinCode;
  String userState;
  String userArea;
  String userHouseNo;
  int userBalance;
  int userId;
  int userOrderNumber;
  bool auth;

  UserModel(
      {this.userCountry,
      this.userPhoneNumber,
      this.userCity,
      this.userHouseNo,
      this.userState,
      this.userEmail,
      this.userName,
      this.userPinCode,
      this.userArea,
      this.userBalance,
      this.userId,
      this.userOrderNumber,
      this.auth});

  UserModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      userCountry = jsonMap['country'].toString();
      userPhoneNumber = jsonMap['phone_no'].toString();
      userCity = jsonMap['city'].toString();
      userHouseNo = jsonMap['address'].toString();
      userId = jsonMap['id'];
      userState = jsonMap['state'].toString();
      userEmail = (jsonMap['email'] == null || jsonMap['email'] == '')
          ? null
          : jsonMap['email'];
      userName = jsonMap['name'].toString();
      userPinCode = jsonMap['pinecode'].toString();
      userArea = jsonMap['area'].toString();
      userBalance = (jsonMap['balance'] == null || jsonMap['balance'] == '')
          ? null
          : int.parse(jsonMap['balance']);
    } catch (e) {
      print(e.toString());
    }
  }

  Map<String, dynamic> toMap() {
    var userMap = new Map<String, dynamic>();
    userMap["name"] = userName;
    userMap["phone_no"] = userPhoneNumber;
    userMap["city"] = userCity;
    userMap["house_no"] = userHouseNo;
    userMap["state"] = userState;
    userMap["pinecode"] = userPinCode.toString();
    userMap["balance"] = "0";
    userMap["area"] = userArea;
    userMap["email"] = userEmail;
    userMap["total_orders"] = "0";
    return userMap;
  }
}
