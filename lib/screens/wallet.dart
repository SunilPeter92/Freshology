import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:freshology/provider/userProvider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freshology/widget/startButton.dart';
import '../controllers/WalletController.dart';
class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends StateMVC<Wallet> {

  WalletController _con;

  _WalletState() : super(WalletController()) {
    _con = controller;
  }


  TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Razorpay _razorpay;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _db = Firestore.instance;
  String userDoc;
  int walletBalance;
  var size;

  @override
  void initState() {
    _con.getWalletAmount();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    userDoc = Provider.of<UserProvider>(context, listen: false).userDocID;
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void openCheckOut() async {
    FirebaseUser _user = await _auth.currentUser();
    int amount = int.parse(_controller.value.text.trim());
    var options = {
      'key': 'rzp_live_M1iVXlW7jxRqYx',
      'amount': amount * 100,
      'name': 'Freshology',
      'description': 'Order payment',
      'prefill': {
        'contact': _user.phoneNumber,
      },
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    onPaymentSuccess();
    Fluttertoast.showToast(msg: 'Payment Success, Money added');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: 'Payment Failed, Try Again');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    onPaymentSuccess();
    Fluttertoast.showToast(msg: 'Payment Success ' + response.walletName);
  }

  Future<void> onPaymentSuccess() async {
    var data = await _db.collection('user').document(userDoc).updateData({
      'balance': walletBalance,
    });
    Provider.of<UserProvider>(context, listen: false).getUserDetail();
  }

  addMoneyPresetWidget(String val, String cashBack) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: kDarkGreen,
        ),
        borderRadius: BorderRadius.circular(15),
        color: kDarkGreen,
      ),
      child: GestureDetector(
        onTap: () {
          _controller.text = val;
        },
        child: Column(
          children: [
            Text(
              "+₹ ${val}",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            Text(
              "₹ ${cashBack} Bashback",
              style: TextStyle(fontSize: 8, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  historyButtons(String icon, String title, Function onTapFunc) {
    return InkWell(
      onTap: () => onTapFunc,
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(5),
        child: Column(
          children: [
            Image.asset(
              "assets/${icon}.png",
              height: 50,
              width: 40,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  billingHistoryData(String title, String value) {
    return Container(
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        trailing: Text("₹ $value"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).userDetail;
    size = MediaQuery.of(context).size;
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: kDarkGreen),
        title: Text(
          'Wallet',
          style: TextStyle(
            color: kDarkGreen,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _con.isLoading,
              child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  // color: Colors.blue,
                  padding: EdgeInsets.all(15),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: size.width * 0.37,
                          child: Column(
                            children: [
                              Text(
                                "Main Balance",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                // "₹ ${_con.wallet.amount}",
                                _con.wallet.amount==null?"₹ ${0.0}":"₹ ${_con.wallet.amount}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Container(
                          width: size.width * 0.37,
                          child: Column(
                            children: [
                              Text(
                                "Promotional Balance",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "₹ balance",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 75),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Add Money",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '₹ 1000',
                        ),
                        validator: (nameValue) {
                          if (nameValue.isEmpty) {
                            return 'Please Enter a amount';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    addMoneyPresetWidget("1000", "10"),
                    addMoneyPresetWidget("2000", "20"),
                    addMoneyPresetWidget("3000", "30"),
                    addMoneyPresetWidget("4000", "40"),
                  ],
                ),
                SizedBox(height: 15),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  child: FlatButton(
                    color: kLightGreen,
                    child: Text(
                      'Add money',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {

                      if (_formKey.currentState.validate()) {
                        _con.updateWallet(_controller.value.text.trim(), 'add');
                        // walletBalance = user.userBalance +
                        //     int.parse(_controller.value.text.trim());
                        // openCheckOut();
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      historyButtons("wallet_history", "Wallet\nHistory", () {}),
                      historyButtons(
                          "billing_history", "Billing\nHistory", () {}),
                      historyButtons("reserve_money", "Reserve\nMoney", () {})
                    ],
                  ),
                ),
                Column(
                  children: [
                    billingHistoryData("Last recharge amount", "0"),
                    billingHistoryData("Balance after last recharge", "0"),
                    billingHistoryData("Bill since last recharge", "0")
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
