import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/controllers/address_controller.dart';
import 'package:freshology/models/route.dart';
import 'package:freshology/provider/userProvider.dart';
import 'package:freshology/widget/startButton.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:freshology/models/Address.dart';
import '../repositories/appListenables.dart';

class AddressEdit extends StatefulWidget {
  RouteArgument routeArgument;
  AddressEdit({this.routeArgument});
  @override
  _AddressEditState createState() => _AddressEditState();
}

class _AddressEditState extends StateMVC<AddressEdit> {
  AddressController _con;

  _AddressEditState() : super(AddressController()) {
    _con = controller;
  }

  String dropArea;
  List<String> areaList = [];
  String dropCity = 'Faridabad';
  List<String> cityList = ['Faridabad'];
  String dropState = 'Haryana';
  List<String> stateList = ['Haryana'];
  Firestore _db = Firestore.instance;
  bool _isSaving = false;

  TextEditingController _houseNoController = TextEditingController();
  TextEditingController _pinCodeController = TextEditingController();

  @override
  void initState() {
    if (widget.routeArgument.param.id != null) {
      _con.address = widget.routeArgument.param;
      _houseNoController.text = _con.address.houseNo;
      _pinCodeController.text = _con.address.pinecode;
      _con.listGetter();
    } else {
      _con.address = widget.routeArgument.param;
      _con.fetched = true;
      _con.getCountry();
    }
    print("ADDRESS EDIT SCREEN CALLED:");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _con.isLoading,
      child: Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: kDarkGreen),
          centerTitle: true,
          title: Text(
            'Address',
            style: TextStyle(
              color: kDarkGreen,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: ModalProgressHUD(
          inAsyncCall: _isSaving,
          child: _con.fetched == false
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 20,
                    ),
                    child: Form(
                      key: _con.formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _houseNoController,
                            decoration: InputDecoration(
                              labelText: 'House no./Flat no. *',
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
                            onChanged: (val) {
                              _con.address.houseNo = val;
                            },
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
                            controller: _pinCodeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Pincode *',
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
                            onChanged: (val) {
                              _con.address.pinecode = val;
                            },
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
                            _con.onAreaChanged,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          StartButton(
                              name: 'Save',
                              onPressFunc: () => _con.saveAddress()),
                        ],
                      ),
                    ),
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
