import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/constants/countries.dart';
import 'package:freshology/controllers/userController.dart';
import 'package:freshology/models/userModel.dart';
// import 'package:freshology/provider/_con.dart';
import 'package:freshology/screens/addressSelection.dart';
import 'package:freshology/widget/startButton.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends StateMVC<Register> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String dropArea;
  String dropCountry;
  List<Map<String, dynamic>> country = countryData;
  List<String> areaList = [];
  String dropCity = 'Faridabad';
  List<String> cityList = ['Faridabad'];
  List<String> countryNamesList = [];
  String dropState = 'Haryana';
  List<String> stateList = ['Haryana'];
  bool _isLoading = false;
  Firestore _fireStore = Firestore.instance;

  UserController _con;
  _RegisterState() : super(UserController()) {
    _con = controller;
  }
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _pinCodeController = TextEditingController();
  TextEditingController _houseNoController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  void getlocData() async {
    setState(() {
      _isLoading = true;
    });
    var data = await _fireStore
        .collection('locations')
        .document('Haryana')
        .collection('cities')
        .document('Faridabad')
        .collection('area')
        .getDocuments();
    for (var i in data.documents) {
      areaList.add(i.data['area_name']);
      print(i.data['area_name']);
    }
    setState(() {
      dropArea = areaList[0] ?? '';
    });
    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> checkUser(String phoneNumber) async {
    var data = await _fireStore.collection('user').getDocuments();
    for (var d in data.documents) {
      if (d.data['phone'] == phoneNumber) {
        return true;
      }
    }
    return false;
  }

  String phone;
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0), () {
      // getlocData();
      _con.getCountry();
      countryNamesList = _con.countryNameList;
      _con.scaffoldKey = scaffoldKey;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cityController.text = 'Faridabad';
    _stateController.text = 'Haryana';

    print("List length : ${_con.countryNameList.length}");
    return Scaffold(
      key: scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 20,
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Text(
                  "REGISTRATION",
                  style: kPageTitleTextStyle,
                ),
                Hero(
                  tag: 'logo',
                  child: Image(
                    image: AssetImage('assets/logo_main.png'),
                    width: 300,
                    height: 200,
                  ),
                ),
                Text(
                  "PLEASE ADD YOUR ADDRESS TO PROCEED",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: kDarkGreen,
                            ),
                            labelText: "Full Name",
                            labelStyle: TextStyle(
                              color: kDarkGreen,
                            ),
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
                          validator: (nameValue) {
                            if (nameValue.isEmpty) {
                              return 'This field is mandatory';
                            } else if (nameValue.length <= 2) {
                              return 'Name must be more than 2 charater';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        IntlPhoneField(
                          controller: _phoneController,
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
                              phone = val.completeNumber;
                            });

                            print("PHONE: ${phone}");
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
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email (Optional)',
                            labelStyle: TextStyle(
                              color: kDarkGreen,
                            ),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: kDarkGreen, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: kDarkGreen,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: kDarkGreen, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onChanged: (val) {},
                          validator: (nameValue) {
                            Pattern pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);
                            if (nameValue.isNotEmpty) {
                              if (!regex.hasMatch(nameValue)) {
                                return 'Enter Valid Email';
                              }
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        addressDropDownFields(
                          "Country",
                          _con.selectedCountry,
                          _con.countryNameList,
                          _con.countryList,
                          true,
                          _con.onCountryChanged,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        addressDropDownFields(
                          "State",
                          _con.selectedState,
                          _con.stateNameList,
                          _con.stateList,
                          _con.showState,
                          _con.onStateChanged,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        addressDropDownFields(
                          "City",
                          _con.selectedCity,
                          _con.cityNameList,
                          _con.cityList,
                          _con.showCity,
                          _con.onCityChanged,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        addressDropDownFields(
                            "Area",
                            _con.selectedArea,
                            _con.areaNameList,
                            _con.areaList,
                            _con.showArea,
                            () {}),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _pinCodeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Pincode',
                            labelStyle: TextStyle(
                              color: kDarkGreen,
                            ),
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
                          validator: (nameValue) {
                            String pattern = r'^(?:[+0]9)?[0-9]{6}$';
                            RegExp regExp = new RegExp(pattern);
                            if (nameValue.isEmpty) {
                              return 'This field is mandatory';
                            } else if (nameValue.trim() !=
                                _con.selectedArea['pincode']) {
                              print("PINCODE: ${_con.selectedArea['pincode']}");

                              return 'Enter a valid pincode';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        StartButton(
                          name: 'PROCEED',
                          onPressFunc: () async {
                            if (_formKey.currentState.validate()) {
                              print("PHONE NO ON  SUBMIT $phone");
                              _con.user = User(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  countryName: _con.selectedCountry['name'],
                                  countryId:
                                      _con.selectedCountry['id'].toString(),
                                  stateName:
                                      _con.selectedState['name'].toString(),
                                  stateId: _con.selectedState['id'].toString(),
                                  cityName: _con.selectedCity['name'],
                                  cityId: _con.selectedCity['id'].toString(),
                                  areaName: _con.selectedArea['name'],
                                  areaId: _con.selectedArea['id'].toString(),
                                  pinCode: _pinCodeController.text);
                              // _con.user = UserModel(
                              //   userCountry: _con.selectedCountry['name'],
                              //   userName: _nameController.value.text,
                              //   userPhoneNumber: phone,
                              //   userCity: _con.selectedCity['name'],
                              //   userHouseNo: _houseNoController.value.text,
                              //   userArea: _con.selectedArea['name'],
                              //   userPinCode: _pinCodeController.value.text,
                              //   userState: _con.selectedState['name'],
                              //   userEmail: _emailController.value.text,
                              // );
                              _con.user.phone = phone;
                              // Navigator.pushNamed(context, 'otp');
                              // _con.registerUser(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddressSelection(
                                    user: _con.user,
                                  ),
                                ),
                              );
                            }
                            // }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'terms');
                          },
                          child: Text(
                            'By clicking on Proceed you agree to the',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: kDarkGreen,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'privacy');
                          },
                          child: Text(
                            'Privacy Policy & Terms and Condition',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  addressDropDownFields(
    String lable,
    var val,
    List<String> nameList,
    List dataList,
    bool visibility,
    Function onChangedCallback,
  ) {
    return Container(
      child: visibility == false
          ? Container()
          : Container(
              child: val == null
                  ? Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: lable,
                        labelStyle: TextStyle(
                          color: kDarkGreen,
                        ),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: kDarkGreen, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.room, color: kDarkGreen),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: kDarkGreen, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      value: val['name'],
                      items: nameList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 13, color: kDarkGreen),
                          ),
                        );
                      }).toList(),
                      onChanged: (item) {
                        if (lable == "Country") {
                          setState(() {
                            _con.selectedCountry = _con.countryList.firstWhere(
                                (loc) => loc['name'] == item,
                                orElse: () => _con.countryList.first);
                          });
                          onChangedCallback();
                        } else if (lable == "State") {
                          setState(() {
                            _con.selectedState = _con.stateList.firstWhere(
                                (loc) => loc['name'] == item,
                                orElse: () => _con.stateList.first);
                          });
                          onChangedCallback();
                        } else if (lable == "City") {
                          setState(() {
                            _con.selectedCity = _con.cityList.firstWhere(
                                (loc) => loc['name'] == item,
                                orElse: () => _con.cityList.first);
                          });
                          onChangedCallback();
                        } else if (lable == "Area") {
                          setState(() {
                            _con.selectedArea = _con.areaList.firstWhere(
                                (loc) => loc['name'] == item,
                                orElse: () => _con.areaList.first);
                          });
                          onChangedCallback();
                        }
                      },
                    ),
            ),
    );
  }
}
