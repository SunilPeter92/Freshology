import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshology/models/promocodesModel.dart';

class PromoProvider extends ChangeNotifier {
  List<PromoModel> codes = [];
  String enteredPromo;
  int cartValue;
  bool popDisplayed = false;
  bool updatePopup = false;
  Firestore _db = Firestore.instance;
  bool isLoading = false;
  bool isApplied = false;
  int deliveryCharge = 30;

  PromoModel selectedCode = PromoModel(
    code: '',
    per: 0,
    minAmount: 0,
    maxDiscount: 0,
  );

  Future<void> getDeliveryCharge(String area) async {
    toggleIsLoading();
    var data = await _db.collection('locations').document('Haryana').collection('cities').document('Faridabad').collection('area').getDocuments();
    for (var i in data.documents) {
      if (area == (i.data['area_name'])) {
        deliveryCharge = i.data['delivery_charge'];
        break;
      }
    }
    print(deliveryCharge);
    toggleIsLoading();
    notifyListeners();
  }

  void toggleIsLoading() {
    isLoading = !isLoading;
  }

  Future<void> fetchPromo() async {
    toggleIsLoading();
    var data = await _db.collection('promocodes').getDocuments();
    for (var d in data.documents) {
      codes.add(PromoModel(
        code: d.data['code'],
        maxDiscount: d.data['max_discount'],
        minAmount: d.data['min_order'],
        per: d.data['discount'],
      ));
    }
    toggleIsLoading();
    notifyListeners();
  }

  bool matchPromo() {
    for (int i = 0; i < codes.length; i++) {
      if (codes[i].code == enteredPromo) {
        selectedCode = PromoModel(
          code: codes[i].code,
          per: codes[i].per,
          maxDiscount: codes[i].maxDiscount,
          minAmount: codes[i].minAmount,
        );
        return true;
      }
    }
    return false;
  }

  Future<String> applyPromo() async {
    await fetchPromo();
    bool res = matchPromo();
    if (res) {
      if (selectedCode.minAmount > cartValue) {
        return 'Minimun cart value should be ${selectedCode.minAmount}';
      }
      isApplied = true;
      return 'Promocode Applied';
    }
    return 'Invalid Promocode!';
  }
}
