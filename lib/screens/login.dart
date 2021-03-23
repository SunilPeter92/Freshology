import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshology/controllers/userController.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:freshology/provider/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/widget/startButton.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends StateMVC<Login> {
  final _form = GlobalKey<FormState>();
  TextEditingController _number = TextEditingController();
  Firestore _fireStore = Firestore.instance;
  String phoneNumber;
  Future<bool> checkUser() async {
    print("PHONE NO: ${phoneNumber}");
    var data = await _fireStore.collection('user').getDocuments();
    for (var d in data.documents) {
      if (d.data['phone'] == phoneNumber) {
        Navigator.pushNamed(context, 'otp');
        return true;
      }
    }
    return false;
  }

  UserController _con;
  _LoginState() : super(UserController()) {
    _con = controller;
  }
  // Future<void> handleLogin() async {
  //   bool res = await checkUser();
  //   if (res == true) {
  //     print("Navigated");
  //   } else {
  //     Navigator.pushNamed(context, 'register');
  //   }
  // }

  Future<bool> _onBackPress() {
    return SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  @override
  void initState() {
    // _con.scaffoldKey = scaffoldKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final userProvider = Provider.of<UserProvider>(context);
    // userProvider.scaffoldKey = scaffoldKey;
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        key: _con.scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Image(
                    image: AssetImage('assets/logoGreen.png'),
                    width: 300,
                    height: 300,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Form(
                    key: _form,
                    child: Column(
                      children: <Widget>[
                        IntlPhoneField(
                          controller: _number,
                          decoration: InputDecoration(
                            labelText: '1234567890',
                            labelStyle: TextStyle(
                              color: kDarkGreen,
                            ),
                            prefixStyle: TextStyle(
                              color: kDarkGreen,
                            ),
                            prefixIcon: Icon(Icons.phone),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: kDarkGreen, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: kDarkGreen, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          initialCountryCode: 'IN',
                          onChanged: (val) {
                            setState(() {
                              phoneNumber = val.completeNumber;
                            });

                            print("PHONE: ${phoneNumber}");
                          },
                          validator: (nameValue) {
                            String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                            RegExp regExp = new RegExp(pattern);
                            if (nameValue.isEmpty) {
                              return 'This field is mandatory';
                            } else if (nameValue.trim().length != 10 ||
                                !regExp.hasMatch(nameValue)) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        StartButton(
                          name: 'Login',
                          onPressFunc: () {
                            if (_form.currentState.validate()) {
                              setState(() {
                                _con.user.phone = phoneNumber;
                              });
                              // print(
                              //     "NEW USER PHONE: ${userProvider.userPhoneNumber}");
                              _con.loginUser(context);
                              // userProvider.loginUser(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'register');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("New user ?"),
                        Text(
                          "  Register.",
                          style: TextStyle(
                            color: kDarkGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
