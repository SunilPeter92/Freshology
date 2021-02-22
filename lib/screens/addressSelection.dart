import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/models/userModel.dart';
import 'package:freshology/provider/userProvider.dart';
import 'package:freshology/widget/startButton.dart';
import 'package:provider/provider.dart';

class AddressSelection extends StatefulWidget {
  UserModel user;
  AddressSelection({@required this.user});
  @override
  _AddressSelectionState createState() => _AddressSelectionState();
}

class _AddressSelectionState extends State<AddressSelection> {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _addLine1 = TextEditingController();
  TextEditingController _addLine2 = TextEditingController();
  String completeAddress;
  UserProvider userProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: true);
    userProvider.scaffoldKey = scaffoldKey;
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _addLine1,
                  decoration: InputDecoration(
                    labelText: 'Address Line 1',
                    labelStyle: TextStyle(
                      color: kDarkGreen,
                    ),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: kDarkGreen, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: Icon(
                      Icons.location_city,
                      color: kDarkGreen,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: kDarkGreen, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (nameValue) {
                    if (nameValue.isEmpty) {
                      return 'This field is mandatory';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _addLine2,
                  decoration: InputDecoration(
                    labelText: 'Address Line 2',
                    labelStyle: TextStyle(
                      color: kDarkGreen,
                    ),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: kDarkGreen, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: Icon(
                      Icons.location_city,
                      color: kDarkGreen,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: kDarkGreen, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                StartButton(
                  name: 'PROCEED',
                  onPressFunc: () async {
                    if (_formKey.currentState.validate()) {
                      // if (await checkUser(phone) == true) {
                      //   Fluttertoast.showToast(
                      //       msg: 'Already Registered');
                      //   Navigator.pushNamed(context, 'login');
                      // } else {
                      userProvider.newUser = UserModel(
                        userCountry: widget.user.userCountry,
                        userName: widget.user.userName,
                        userPhoneNumber: widget.user.userPhoneNumber,
                        userCity: widget.user.userCity,
                        userHouseNo: "${_addLine1.text} ${_addLine2.text}",
                        userArea: widget.user.userArea,
                        userPinCode: widget.user.userPinCode,
                        userState: widget.user.userState,
                        userEmail: widget.user.userState,
                      );
                      userProvider.userPhoneNumber =
                          widget.user.userPhoneNumber;
                      userProvider.registerUser(context);
                    }
                    // }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
