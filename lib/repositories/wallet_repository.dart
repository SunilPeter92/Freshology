import 'dart:convert';

import 'package:freshology/constants/configurations.dart';
import 'package:freshology/helpers/helper.dart';
import 'package:http/http.dart' as http;
import 'package:freshology/models/Wallet.dart' ;

Future<UserWallet> getWallet(String user_id) async {
  final url = "${baseURL}get_user_wallet/$user_id";
  try {
    var response = await http.get(url, headers: header);
    if (response.statusCode == 201 || response.statusCode == 200) {
      var data = Helper.getData(json.decode(response.body));
      UserWallet wallet = UserWallet.fromJson(data);
      return wallet;
    }else{
      return null;
    }

  } catch (e) {
    print("ERROR! ${e}");
    return null;
  }
}

Future<bool> updateWallet(
  String amount,
  String user_id, {
  String type = 'add',
}) async {
  String url = '';
  if (type == 'add') {
    url = "${baseURL}add_user_wallet";
  } else {
    url = "${baseURL}deduct_user_wallet";
  }
  Map<String, dynamic> param = {
    "user_id": user_id,
    "amount": amount,
  };
  try {
    var response =
        await http.post(url, headers: header, body: json.encode(param));
    if (response.statusCode == 201 || response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      if (decodedResponse['status'] == "success") {
        return true;
      } else {
        return false;
      }
    }
  } catch (e) {
    print("ERROR! ${e}");
    return false;
  }
}
