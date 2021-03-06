import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/provider/cartProvider.dart';
import 'package:freshology/provider/orderProvider.dart';
import 'package:freshology/provider/promoProvider.dart';
import 'package:freshology/provider/userProvider.dart';
import 'package:freshology/repositories/user_repository.dart';
import 'package:freshology/widget/startButton.dart';
import 'package:freshology/widget/timeSlotPicker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../repositories/appListenables.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  DateTime deliveryDate = DateTime.now();
  TimeOfDay deliveryTime;
  bool _isSaving = false;
  Firestore _fireStore = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String orderID;
  String paymentMethod = '';
  Razorpay _razorpay;
  int startTime = 7;
  int endTime = 21;

  Future<bool> _onTimePressed() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Delivery Time',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              content: Text(
                'Please select a delivery slot.',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void getDeliveryTimings() async {
    setState(() {
      _isSaving = true;
    });
    var d = await _fireStore
        .collection('general')
        .document('delivery_timings')
        .get();
    if (deliveryDate.day == DateTime.now().day) {
      setState(() {
        startTime = d.data['start'];
        endTime = d.data['end'];
      });
    } else {
      setState(() {
        startTime = 7;
        endTime = 21;
      });
    }
    setState(() {
      _isSaving = false;
    });
  }

  void openCheckOut() async {
    FirebaseUser _user = await _auth.currentUser();
    int amount = Provider.of<CartProvider>(context, listen: false).grandTotal;
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

  void cleanList() {
    Provider.of<CartProvider>(context, listen: false).cartProducts.clear();
    Provider.of<CartProvider>(context, listen: false).productNames.clear();
    Provider.of<CartProvider>(context, listen: false).itemCount = 0;
    Provider.of<CartProvider>(context, listen: false).totalValue = 0;
    Provider.of<CartProvider>(context, listen: false).grandTotal = 0;
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    //Fluttertoast.showToast(msg: 'Payment Success, Order Placed');
    paymentMethod = 'RazorPay';
    await saveOrder();
    //Navigator.pushNamed(context, 'confirm');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: 'Payment Failed, Try Again');
  }

  void _handleExternalWallet(ExternalWalletResponse response) async {
    Fluttertoast.showToast(msg: 'External Wallet' + response.walletName);
    paymentMethod = 'External Wallet';
    await saveOrder();
    //Navigator.pushNamed(context, 'confirm');
  }

  void _handleCoD() async {
    setState(() {
      _isSaving = true;
    });
    paymentMethod = 'Cash on Delivery';
    await saveOrder();
    //Fluttertoast.showToast(msg: 'Order Placed');
    setState(() {
      _isSaving = false;
    });
    //Navigator.pushNamed(context, 'confirm');
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getDeliveryTimings();
    });
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _handleInternalWallet(int val) async {
    setState(() {
      _isSaving = true;
      paymentMethod = 'Freshology Wallet';
    });
    String userDocId =
        Provider.of<UserProvider>(context, listen: false).userDocID;
    await _fireStore.collection('user').document(userDocId).updateData({
      'balance': val,
    });
    Provider.of<UserProvider>(context, listen: false).getUserDetail();
    await saveOrder();
    setState(() {
      _isSaving = false;
    });
    //Navigator.pushNamed(context, 'confirm');
  }

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> saveOrder() async {
    setState(() {
      _isSaving = true;
    });
    String orderDocId;
    var num =
        await _fireStore.collection('general').document('invoice_number').get();
    int invoiceID = num.data['invoice_number'];
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false).userDetail;
    final userDocID =
        Provider.of<UserProvider>(context, listen: false).userDocID;
    orderID = "4534";
    // save user data in orders db
    final userProvider =
        Provider.of<UserProvider>(context, listen: false).userDetail;
    final promoProvider = Provider.of<PromoProvider>(context, listen: false);
    var _res = await _fireStore.collection('orders').add({
      'amount': cartProvider.grandTotal.toString(),
      'c_name': userProvider.name,
      'c_house': userProvider.houseNo,
      'c_state': userProvider.stateName,
      'c_phone': userProvider.phone,
      'c_city': userProvider.cityName,
      'c_area': userProvider.areaName,
      'c_pincode': userProvider.pinCode,
      'order_id': orderID,
      'time': DateTime.now(),
      'is_completed': false,
      'user_doc_ic': userDocID,
      'delivery_date': deliveryDate,
      'delivery_time': deliveryTime.hour.toString(),
      'payment_method': paymentMethod,
      'discount': cartProvider.discount,
      'delivery_charge': cartProvider.deliveryCharge,
      'delivery_amount': promoProvider.deliveryCharge,
      'invoice_number': 'FSFDH20-' + invoiceID.toString(),
    });
    // Save orders item in order db //
    orderDocId = _res.documentID;
    await _fireStore
        .collection('orders')
        .document(orderDocId)
        .collection('order_status')
        .add({
      'order_status': '',
    });
    Provider.of<OrderProvider>(context, listen: false).savedOrderID =
        orderDocId;
    final cartProducts =
        Provider.of<CartProvider>(context, listen: false).cartProducts;
    cartProducts.forEach((item) async {
      await _fireStore
          .collection('orders')
          .document(orderDocId)
          .collection('items')
          .add({
        'name': item.productName,
        'price': item.productPrice,
        'weight': item.productWeight,
        'quantity': item.productQuantity,
        'SKU': item.sKU,
        'CGST': item.cGST,
        'IGST': item.iGST,
        'HSN/SAC': item.hSN,
        'SGST': item.sGST,
      });
    });
    String userDocId =
        Provider.of<UserProvider>(context, listen: false).userDocID;
    // Save order id in user //
    await _fireStore
        .collection('user')
        .document(userDocId)
        .collection('orders')
        .document(orderDocId)
        .setData({
      'orderDocID': orderDocId,
    });
    await _fireStore
        .collection('user')
        .document(userDocId)
        .updateData({'total_orders': FieldValue.increment(1)});
    await _fireStore
        .collection('general')
        .document('invoice_number')
        .updateData({'invoice_number': invoiceID + 1});
    Provider.of<UserProvider>(context, listen: false).getUserDetail();
    setState(() {
      cleanList();
      _isSaving = false;
      Navigator.pushNamed(context, 'confirm');
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final user = currentUser.value;
    final userProvider = Provider.of<UserProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    deliveryTime = Provider.of<OrderProvider>(context).deliveryTime;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: kDarkGreen),
        title: Text(
          'Payment',
          style: TextStyle(color: kDarkGreen),
        ),
        backgroundColor: Colors.white,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isSaving,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Order Summary',
                              style: kCartGrandTotalTextStyle,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Total items',
                                style: kCartPaymentTextStyle,
                              ),
                              Text(
                                cartProvider.cartProducts.length.toString(),
                                style: kCartPaymentTextStyle,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Grand Total',
                                style: kCartPaymentTextStyle,
                              ),
                              Text(
                                '₹ ' + cartProvider.grandTotal.toString(),
                                style: kCartPaymentTextStyle,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Delivery Address : ',
                                  style: kCartPaymentTextStyle,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  '${user.houseNo}, ${user.areaName}, '
                                  '${user.cityName}',
                                  style: kCartPaymentTextStyle,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, 'addresses')
                                  .then((value) async {
                                await userProvider.getUserDetail();
                                await orderProvider.getUserDetail();
                              });
                            },
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Change Address",
                                style: TextStyle(
                                  color: kDarkGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          // StartButton(
                          //   name: 'Change Address',
                          //   onPressFunc: () {},
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Delivery Slot " +
                                        deliveryDate.day.toString() +
                                        '/' +
                                        deliveryDate.month.toString() +
                                        "/" +
                                        deliveryDate.year.toString(),
                                    textAlign: TextAlign.left,
                                    style: kCartGrandTotalTextStyle,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    deliveryDate.day.toString() +
                                        '/' +
                                        deliveryDate.month.toString() +
                                        "/" +
                                        deliveryDate.year.toString(),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          TimeSlotPicker(
                            deliveryDay: deliveryDate,
                            end: endTime,
                            start: startTime,
                          ),
                          SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              DatePicker.showDatePicker(
                                context,
                                minTime: DateTime.now(),
                                maxTime: DateTime.now().add(Duration(days: 4)),
                                onConfirm: (value) {
                                  setState(() {
                                    deliveryDate = value;
                                  });
                                  getDeliveryTimings();
                                },
                              );
                            },
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Select Delivery Date",
                                style: TextStyle(
                                  color: kDarkGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          // StartButton(
                          //   name: 'Select Delivery Date',
                          //   onPressFunc: () {

                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),

//                Text(
//                  'Delivery time may vary by +/- 1 hour from the selected '
//                  'time',
//                  style: TextStyle(
//                    fontSize: 12,
//                    color: Colors.black54,
//                  ),
//                ),
                //SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 20,
                  ),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Payment Methods',
                            style: kCartGrandTotalTextStyle,
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: kDarkGreen,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: kDarkGreen,
                            ),
                            child: ListTile(
                              leading: Icon(
                                FontAwesomeIcons.wallet,
                                size: 16,
                                color: Colors.white,
                              ),
                              title: Text(
                                'Freshology Cash',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              trailing: Text(
                                '₹ user balance',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                // if (deliveryTime == null) {
                                //   _onTimePressed();
                                // } else {
                                //   if (cartProvider.grandTotal <
                                //       user.userBalance) {
                                //     int remBal = user.userBalance -
                                //         cartProvider.grandTotal;
                                //     _handleInternalWallet(remBal);
                                //   } else {
                                //     Fluttertoast.showToast(
                                //         msg: 'Not enough balance!');
                                //   }
                                // }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: kDarkGreen,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: kDarkGreen,
                            ),
                            child: ListTile(
                              leading: Icon(
                                FontAwesomeIcons.creditCard,
                                size: 16,
                                color: Colors.white,
                              ),
                              title: Text(
                                'NetBanking/Cards/Wallets',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              trailing: Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: 16,
                              ),
                              onTap: () {
                                if (deliveryTime == null) {
                                  _onTimePressed();
                                } else {
                                  openCheckOut();
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: kDarkGreen,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: kDarkGreen,
                            ),
                            child: ListTile(
                              leading: Icon(
                                FontAwesomeIcons.rupeeSign,
                                size: 16,
                                color: Colors.white,
                              ),
                              title: Text(
                                'Pay on Delivery (Cash/Paytm/UPI)',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              trailing: Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: 16,
                              ),
                              onTap: () {
                                if (deliveryTime == null) {
                                  _onTimePressed();
                                } else {
                                  _handleCoD();
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
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
}
