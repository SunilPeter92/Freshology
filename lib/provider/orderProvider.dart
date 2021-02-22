import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshology/models/orderModel.dart';
import 'package:freshology/models/userInvoiceModel.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> orderList = [];
  String userDocId;
  List<DocList> ordersDocList = [];
  int selectedIndex;
  bool isLoading = false;
  bool checkDelivery;
  TimeOfDay deliveryTime;
  Firestore _db = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  InvoiceUser invoiceUser = InvoiceUser(
    name: '',
    phone: '',
    address: '',
    state: '',
  );
//  OrderProductModel withFee = OrderProductModel(
//    name: 'Delivery Charge',
//    weight: '',
//    price: '30',
//    quantity: 1,
//    cGST: 9,
//    hSN: '00000000',
//    iGST: 18,
//    sGST: 9,
//    sKU: '',
//  );
//  OrderProductModel withoutFee = OrderProductModel(
//    name: 'Delivery Charge',
//    weight: '',
//    price: '0',
//    quantity: 1,
//    cGST: 9,
//    hSN: '00000000',
//    iGST: 18,
//    sGST: 9,
//    sKU: '',
//  );
  String savedOrderID;

  void updateTime() {
    deliveryTime = deliveryTime;
    notifyListeners();
  }

  void toggleIsLoading() {
    isLoading = !isLoading;
  }

  Future<void> getUserDetail() async {
    FirebaseUser _user = await _auth.currentUser();
    if (_user != null) {
      String userNum = _user.phoneNumber;
      var data = await _db.collection('user').getDocuments();
      for (var d in data.documents) {
        if (d.data['phone'] == userNum) {
          userDocId = d.documentID;
          invoiceUser.phone = d.data['phone'];
          invoiceUser.name = d.data['name'];
          invoiceUser.state = d.data['state'];
          invoiceUser.address = d.data['house_no'] + ", " + d.data['area'] + ", " + d.data['city'];
          break;
        }
      }
    }
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    toggleIsLoading();
    orderList.clear();
    ordersDocList.clear();
    await getUserDetail();
    var data = await _db.collection('user').document(userDocId).collection('orders').getDocuments();
    for (var d in data.documents) {
      ordersDocList.add(DocList(
        id: d.data['orderDocID'],
        link: d.data['invoice_link'],
      ));
    }
    for (var i in ordersDocList) {
      List<OrderProductModel> orderItemsList = [];
      orderItemsList.clear();
      var item = await _db.collection('orders').document(i.id).get();
      var items = await _db.collection('orders').document(i.id).collection('items').getDocuments();
      for (var x in items.documents) {
        orderItemsList.add(OrderProductModel(
          price: x.data['price'],
          weight: x.data['weight'],
          quantity: x.data['quantity'],
          name: x.data['name'],
          sGST: x.data['SGST'],
          iGST: x.data['IGST'],
          cGST: x.data['CGST'],
          hSN: x.data['HSN/SAC'],
          sKU: x.data['SKU'],
        ));
      }
      var status = await _db.collection('orders').document(i.id).collection('order_status').getDocuments();
      var s = status.documents;
      orderList.add(
        OrderModel(
          orderStatus: s[0].data['order_status'],
          link: i.link,
          orderAmount: item.data['amount'],
          orderID: item.data['order_id'],
          orderTime: item.data['time'],
          orderDeliveryDate: item.data['delivery_date'],
          orderDeliveryTime: item.data['delivery_time'],
          orderIsComplete: item.data['is_completed'],
          orderPaymentMethod: item.data['payment_method'],
          orderItems: orderItemsList,
          deliveryCharge: item.data['delivery_charge'],
          discount: item.data['discount'],
          invoiceId: item.data['invoice_number'],
        ),
      );
//      if (item.data['delivery_charge']) {
//        int amount = item.data['delivery_amount'];
//        if (amount != null) {
//          withFee.price = amount.toString();
//        }
//        orderItemsList.add(withFee);
//      } else {
//        orderItemsList.add(withoutFee);
//      }
//      withFee.price = '30';
    }
    orderList.sort((b, a) {
      return a.orderTime.compareTo(b.orderTime);
    });
    toggleIsLoading();
    notifyListeners();
  }
}

class DocList {
  String id;
  String link;
  DocList({
    this.id,
    this.link,
  });
}
