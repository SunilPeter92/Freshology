import 'dart:convert';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:freshology/constants/configurations.dart';
import 'package:freshology/models/Address.dart';
import 'package:freshology/repositories/appListenables.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repositories/user_repository.dart' as userRepo;
import 'package:http/http.dart' as http;

class AddressController extends ControllerMVC {
  List<Address> addresses = <Address>[];
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Address selectedAddress;
  bool showAll = true;
  Address address;
  bool fetched = false;
  List<Map<String, dynamic>> countryList = [];
  List<String> countryNameList = [];
  List<String> stateNameList = [];
  List<String> cityNameList = [];
  List<String> areaNameList = [];
  var selectedCountry;
  var selectedCity;
  var selectedState;
  var selectedArea;
  bool showState = false;
  bool showCity = false;
  bool showArea = false;
  List<Map<String, dynamic>> stateList = [];
  List<Map<String, dynamic>> cityList = [];
  List<Map<String, dynamic>> areaList = [];

  DeliveryAddressesController() {
    listenForAddresses();
  }

  void listenForAddresses({String message}) async {
    final Stream<Address> stream = await userRepo.getAddresses();
    stream.listen((Address _address) {
      setState(() {
        addresses.add(_address);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Verify your internet connection"),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshAddresses() async {
    addresses.clear();
    listenForAddresses(message: "Address refreshed successfully");
  }

  void addAddress(context  , Address address) {
    setState(() {
      isLoading = true;
    });
    userRepo.addAddress(address).then((value) {
      if (value == "success") {
        setState(() {
          isLoading = false;
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("New address added successfully"),
        ));
        Navigator.pop(context);
      } else {
        setState(() {
          isLoading = false;
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Something went wrong"),
        ));
      }
    });
  }

  // void chooseDeliveryAddress(Address address) {
  //   userRepo.deliveryAddress = address;
  //   print("ADDRESS: ${userRepo.deliveryAddress.address}");
  // }

  void updateAddress(BuildContext context ,) {
//    if (address.isDefault) {
//      this.addresses.map((model.Address _address) {
//        setState(() {
//          _address.isDefault = false;
//        });
//      });
//    }
    setState(() {
      isLoading = true;
    });

    print("ADDRESS ID : ${address.id}");
    userRepo.updateAddress(address).then((value) {
      if (value == "success") {
        setState(() {
          isLoading = false;
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Address editted successfully"),
        ));
        Navigator.pop(context);
      } else {
        setState(() {
          isLoading = false;
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Something went wrong"),
        ));
      }
    });
  }

  void removeDeliveryAddress(Address address) async {
    userRepo.removeDeliveryAddress(address).then((value) {
      setState(() {
        this.addresses.remove(address);
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Delivery Address removed successfully"),
      ));
    });
  }

  //////////////////////////////////////////////////////////////
  ///////////////ADDRESS LIST FUNCTIONS/////////////////////////
  //////////////////////////////////////////////////////////////

  void onCountryChanged() async {
    showState = true;
    showCity = false;
    showArea = false;
    nameListNullSetter(false, true, true, true);
    getState(selectedCountry["id"].toString());
    address.country = selectedCountry['name'];
    address.countryId = selectedCountry['id'].toString();
    notifyListeners();
  }

  void onStateChanged() async {
    showState = true;
    showCity = true;
    showArea = false;
    nameListNullSetter(false, false, true, true);
    getCity(selectedState['id'].toString());
    address.state = selectedState['name'];
    address.stateId = selectedState['id'].toString();
    notifyListeners();
  }

  void onCityChanged() async {
    showState = true;
    showCity = true;
    showArea = true;
    nameListNullSetter(false, false, false, true);
    getArea(selectedCity['id'].toString());
    address.city = selectedCity['name'];
    address.cityId = selectedCity['id'].toString();
    notifyListeners();
  }

  void onAreaChanged() async {
    address.area = selectedArea['name'];
    address.areaId = selectedArea['id'].toString();
    notifyListeners();
  }

  getCountry() async {
    notifyListeners();
    final url = "${baseURL}get_country";
    final response = await http.get(url);
    print("Country URL: $url");
    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      Map<String, dynamic> _data = json.decode(response.body);

      for (var countries in _data['data']) {
        countryList.add({"name": countries['name'], "id": countries['id']});
        countryNameList.add(countries['name']);
      }

      if (address != null)
        _data['data'].forEach((data) {
          if (data['name'] == address.country) {
            selectedCountry = data;
          }
        });
      selectedCountry == null ? selectedCountry = _data['data'][0] : null;

      notifyListeners();
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Something went wrong'),
      ));
    }
  }

  nameListNullSetter(country, state, city, area) {
    countryNameList = country ? [] : countryNameList;
    stateNameList = state ? [] : stateNameList;
    cityNameList = city ? [] : cityNameList;
    areaNameList = area ? [] : areaNameList;
    notifyListeners();
  }

  getState(String id) async {
    final url = "${baseURL}get_state/$id";
    print("STATE URL: ${url}");
    final response = await http.get(url);
    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      Map<String, dynamic> _data = json.decode(response.body);
      if (_data['data'].isEmpty) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content:
              Text("Sorry, we don't deliver in ${selectedCountry['name']}"),
        ));
        showState = false;
        showCity = false;
        showArea = false;
        notifyListeners();
      } else {
        for (var states in _data['data']) {
          stateList.add({"name": states['name'], "id": states['id']});
          stateNameList.add(states['name']);
        }
        if (address != null)
          _data['data'].forEach((data) {
            if (data['name'] == address.state) {
              selectedState = data;
            }
          });
        selectedState == null ? selectedState = _data["data"][0] : null;

        notifyListeners();
      }
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Something went wrong'),
      ));
    }
  }

  getCity(String id) async {
    notifyListeners();
    final url = "${baseURL}get_city/$id";
    print("City URL: ${url}");
    final response = await http.get(url);
    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      Map<String, dynamic> _data = json.decode(response.body);
      for (var city in _data['data']) {
        cityList.add({"name": city['name'], "id": city['id']});
        cityNameList.add(city['name']);
      }
      if (address != null)
        _data['data'].forEach((data) {
          if (data['name'] == address.city) {
            selectedCity = data;
          }
        });
      selectedCity == null ? selectedCity = _data["data"][0] : null;

      notifyListeners();

      print(response.body);
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Something went wrong'),
      ));
    }
  }

  getArea(String id) async {
    notifyListeners();
    final url = "${baseURL}get_area/$id";
    print("City URL: ${url}");
    final response = await http.get(url);
    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      Map<String, dynamic> _data = json.decode(response.body);
      for (var area in _data['data']) {
        areaList.add({
          "name": area['name'],
          "id": area['id'],
          "pincode": area['pincode']
        });
        areaNameList.add(area['name']);
      }
      if (address != null)
        _data['data'].forEach((data) {
          if (data['name'] == address.area) {
            selectedArea = data;
          }
        });
      selectedArea == null ? selectedArea = _data["data"][0] : null;
      notifyListeners();

      print(response.body);
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Something went wrong'),
      ));
    }
  }

  saveAddress() async {
    if (!formKey.currentState.validate() ||
        (address.areaId == '' || address.areaId == null) ||
        (address.stateId == '' || address.stateId == null) ||
        (address.cityId == '' || address.cityId == null) ||
        (address.countryId == '' || address.countryId == null)) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please select all fields'),
      ));
    } else {
      address.userId = currentUser.value.id.toString();
      addAddress(BuildContext ,this.address);
    }
  }

  listGetter() async {
    await getCountry();
    await getState(address.countryId);
    await getCity(address.cityId);
    await getArea(address.areaId);
    showState = true;
    showCity = true;
    showArea = true;
    fetched = true;
    setState(() {});
  }
}
