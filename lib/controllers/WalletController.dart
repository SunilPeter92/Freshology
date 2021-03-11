import 'package:flutter/material.dart';
import 'package:freshology/models/userModel.dart';
import 'package:freshology/repositories/appListenables.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repositories/wallet_repository.dart' as wRepo;
import '../models/Wallet.dart';

class WalletController extends ControllerMVC {
  UserWallet wallet = UserWallet();
  bool isLoading = true;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  getWalletAmount() async {
    User _user = currentUser.value;
    var _req = await wRepo.getWallet(_user.id);
    if (_req != null) {
      wallet = _req;
      setState(() {
        isLoading = false;
      });
    } else {
      wallet.amount = "0.0";
      scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text("Something went wrong"),
      ));
    }
  }

  updateWallet(String amount, String type) async {
    User _user = currentUser.value;
    isLoading = true;
    setState(() {});
    var _req = await wRepo.updateWallet(amount, _user.id, type: type);

    if (_req == true) {
      getWalletAmount();
      type == "add"?
      scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text("Topup Successfull!"),
      )):null;
    } else {
      scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text("Something went wrong"),
      ));
    }
  }
}
