import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/provider/userProvider.dart';
import 'package:freshology/repositories/user_repository.dart';
import 'package:freshology/widget/startButton.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:freshology/models/Address.dart';

class AddressEdit extends StatefulWidget {
  Address address;
  AddressEdit({this.address});
  @override
  _AddressEditState createState() => _AddressEditState();
}

class _AddressEditState extends State<AddressEdit> {
  final _formKey = GlobalKey<FormState>();
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

  void updateValue() async {
    await Provider.of<UserProvider>(context, listen: false).getUserDetail();
    setState(() {
      _houseNoController.text =
          Provider.of<UserProvider>(context, listen: false).userDetail.houseNo;
      dropArea =
          Provider.of<UserProvider>(context, listen: false).userDetail.areaId;
      _pinCodeController.text =
          Provider.of<UserProvider>(context, listen: false).userDetail.pinCode;
    });
  }

  @override
  void initState() {
    final user = currentUser.value;
    _houseNoController.text = user.houseNo;
    _pinCodeController.text = user.pinCode;
    dropArea = user.areaName;
    areaList.add(dropArea);
    Future.delayed(Duration.zero, () {
      getlocData();
    });
    super.initState();
  }

  void getlocData() async {
    setState(() {
      _isSaving = true;
    });
    var data = await _db
        .collection('locations')
        .document('Haryana')
        .collection('cities')
        .document('Faridabad')
        .collection('area')
        .getDocuments();
    for (var i in data.documents) {
      if (!areaList.contains(i.data['area_name'])) {
        areaList.add(i.data['area_name']);
      }
    }
    setState(() {
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String userDocID = Provider.of<UserProvider>(context).userDocID;
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
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
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _houseNoController,
                    decoration: InputDecoration(
                      labelText: 'House no./Flat no. *',
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: kDarkGreen, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
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
                  DropdownButtonFormField(
                    isExpanded: false,
                    decoration: InputDecoration(
                      labelText: 'Area',
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: kDarkGreen, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: kDarkGreen, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    value: dropArea,
                    items:
                        areaList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        dropArea = value;
                      });
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
                        borderSide:
                            const BorderSide(color: kDarkGreen, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
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
                  DropdownButtonFormField(
                    isExpanded: false,
                    decoration: InputDecoration(
                      labelText: 'City',
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: kDarkGreen, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: kDarkGreen, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    value: dropCity,
                    items:
                        cityList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        dropCity = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    isExpanded: false,
                    decoration: InputDecoration(
                      labelText: 'State',
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: kDarkGreen, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: kDarkGreen, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    value: dropState,
                    items:
                        stateList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        dropState = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  StartButton(
                    name: 'Save',
                    onPressFunc: () async {
                      setState(() {
                        _isSaving = true;
                      });
                      await _db
                          .collection('user')
                          .document(userDocID)
                          .updateData({
                        'house_no': _houseNoController.value.text,
                        'area': dropArea,
                        'pincode': _pinCodeController.value.text,
                      });
                      setState(() {
                        updateValue();
                        _isSaving = false;
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
