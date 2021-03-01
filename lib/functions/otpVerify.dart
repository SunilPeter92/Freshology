import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/controllers/userController.dart';
import 'package:freshology/models/route.dart';
import 'package:freshology/repositories/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:freshology/provider/userProvider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:freshology/widget/startButton.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;

class OtpVerify extends StatefulWidget {
  RouteArgument routeArgument;
  OtpVerify({Key key, this.routeArgument}) : super(key: key);
  @override
  _OtpVerifyState createState() => _OtpVerifyState();
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class _OtpVerifyState extends StateMVC<OtpVerify> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  int forceResendingTokenValue;
  String verificationIdValue;
  TextEditingController _pin = TextEditingController();
  String pinEntered;
  bool _isSaving = false;

  UserController _con;
  _OtpVerifyState() : super(UserController()) {
    _con = controller;
  }
  // Future<void> loginUser(String phone, BuildContext context) async {
  //   await _auth.verifyPhoneNumber(
  //     phoneNumber: phone,
  //     timeout: Duration(seconds: 60),
  //     verificationCompleted: (AuthCredential credential) async {
  //       AuthResult result = await _auth.signInWithCredential(credential);
  //       FirebaseUser user = result.user;
  //       if (user != null) {
  //         //Navigator.pushNamed(context, "home");
  //         registerNewUser();
  //       } else {
  //         print("Error occured");
  //         Fluttertoast.showToast(msg: 'Something went wrong, Try again!');
  //       }
  //     },
  //     verificationFailed: (AuthException exception) {
  //       print(exception.message);
  //       print("verification failed");
  //       Fluttertoast.showToast(msg: 'Invalid OTP');
  //     },
  //     codeSent: (String verificationID, [int forceResendingToken]) async {
  //       setState(() {
  //         forceResendingTokenValue = forceResendingToken;
  //         verificationIdValue = verificationID;
  //       });
  //     },
  //     codeAutoRetrievalTimeout: null,
  //   );
  // }

  // void codeSentFunction(String verificationID,
  //     [int forceResendingToken]) async {
  //   final code = _pin.text.trim();
  //   AuthCredential credential = PhoneAuthProvider.getCredential(
  //       verificationId: verificationID, smsCode: code);
  //   AuthResult result = await _auth.signInWithCredential(credential);
  //   FirebaseUser user = result.user;
  //   if (user != null) {
  //     //Navigator.pushNamed(context, "home");
  //     registerNewUser();
  //   } else {
  //     print("Error");
  //     Fluttertoast.showToast(msg: 'Something went wrong, Try again!');
  //   }
  // }

  // void registerNewUser() async {
  //   setState(() {
  //     _isSaving = true;
  //   });
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   if (userProvider.newUser.userName != '') {
  //     // await userProvider.registerUser(userProvider.newUser);
  //   }
  //   Navigator.pushNamed(context, "home");
  //   setState(() {
  //     _isSaving = false;
  //   });
  // }
  // otpVerification(String phone, String code, BuildContext context) async {
  //   setState(() {
  //     _isSaving = true;
  //   });
  //   String addURL = widget.isLogin ? "login_verifed" : "number_verifed";
  //   final String url = "http://a018.autosandtools.com/api/$addURL";
  //   Map<String, dynamic> param = {"code": code.toString(), "phone_no": phone};
  //   try {
  //     final response = await http.post(url, body: param);
  //     print("Request uploaded ${param})}");
  //     print("STATUS CODE uploaded ${response.statusCode}");
  //     var body = json.decode(response.body);
  //     setState(() {
  //       _isSaving = false;
  //     });

  //     if (body['status'] == "verification code not match") {
  //       scaffoldKey.currentState.showSnackBar(SnackBar(
  //         content: Text("Invalid code entered"),
  //       ));
  //     } else {
  //       Navigator.pushNamed(context, "home");
  //     }
  //   } catch (e) {
  //     print("ERROR !!!!  ${e.toString()}");
  //     return null;
  //   }
  // }

  @override
  void initState() {
    _con.user = currentUser.value;
    _con.scaffoldKey = scaffoldKey;
    Future.delayed(Duration.zero, () {
      // loginUser(
      //     Provider.of<UserProvider>(context, listen: false).userPhoneNumber,
      //     context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "VERIFICATION",
          style: TextStyle(
            color: kDarkGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isSaving,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Image(
                    image: AssetImage('assets/logo_main.png'),
                    width: 220,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "OTP Verification",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 30),
                PinCodeTextField(
                  length: 4,
                  obsecureText: false,
                  animationType: AnimationType.fade,
                  shape: PinCodeFieldShape.box,
                  animationDuration: Duration(milliseconds: 300),
                  inactiveColor: kDarkGreen,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  fieldHeight: 50,
                  fieldWidth: 40,
                  autoDismissKeyboard: true,
                  textInputType: TextInputType.number,
                  controller: _pin,
                  onChanged: (value) {
                    pinEntered = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Enter the code sent to ",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _con.user.phone,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: StartButton(
                    name: 'Verify',
                    onPressFunc: () {
                      _con.verifyRegister(code: _pin.text);
                      // otpVerification(widget.phoneNo, _pin.text, context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
