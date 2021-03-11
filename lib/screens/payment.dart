import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/controllers/checkout_controller.dart';
import 'package:freshology/models/timeSlots.dart';
import 'package:freshology/models/userModel.dart';

import 'package:freshology/provider/cartProvider.dart';
import 'package:freshology/provider/orderProvider.dart';
import 'package:freshology/provider/promoProvider.dart';
import 'package:freshology/provider/userProvider.dart';
import 'package:freshology/repositories/user_repository.dart';
import 'package:freshology/widget/startButton.dart';
import 'package:freshology/widget/timeSlotPicker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../repositories/appListenables.dart';
import 'package:freshology/models/payment.dart' as pay;

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends StateMVC<Payment> {
  CheckoutController _con;
  _PaymentState() : super(CheckoutController()) {
    _con = controller;
  }
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
    int amount = _con.total.toInt();
    var options = {
      'key': 'rzp_live_M1iVXlW7jxRqYx',
      'amount': amount * 100,
      'name': 'Freshology',
      'description': 'Order payment',
      'prefill': {
        'contact': user.phone,
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
    // await saveOrder();
    //Navigator.pushNamed(context, 'confirm');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: 'Payment Failed, Try Again');
  }

  void _handleExternalWallet(ExternalWalletResponse response) async {
    Fluttertoast.showToast(msg: 'External Wallet' + response.walletName);
    paymentMethod = 'External Wallet';
    // await saveOrder();
    //Navigator.pushNamed(context, 'confirm');
  }

  @override
  void initState() {
    User user = currentUser.value;
    _con.deliveryFee = double.parse(user.addresses[0].deliveryFee).toDouble();
    _con.listenForCarts();
    Future.delayed(Duration.zero, () {
      getDeliveryTimings();
    });
    _con.listenForTimeSlots();
    _con.getWalletAmount();
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

  slotSelectedChecker() {
    List<TimeSlot> _slots = [];
    _con.timeSlots.forEach((s) {
      if (s.checked) {
        _slots.add(s);
      }
    });
    print("SLOT: ${_slots.length}");
    if (_slots.length < 1) {
      return false;
    } else {
      return true;
    }
  }

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final user = currentUser.value;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

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
        inAsyncCall: _con.loading,
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
                                _con.carts.length.toString(),
                                style: kCartPaymentTextStyle,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Sub Total',
                                style: kCartPaymentTextStyle,
                              ),
                              Text(
                                '₹ ' + _con.subTotal.toString(),
                                style: kCartPaymentTextStyle,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Delivery Fee',
                                style: kCartPaymentTextStyle,
                              ),
                              Text(
                                '₹ ' + _con.deliveryFee.toString(),
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
                                '₹ ' + _con.total.toString(),
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
                                  '${user.addresses[0].houseNo}, ${user.addresses[0].area}, '
                                  '${user.addresses[0].city}',
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
                                    "Delivery Slot ",
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
                          _con.timeSlots.length == 0
                              ? Container()
                              : TimeSlotPicker(
                                  deliveryDay: deliveryDate,
                                  end: endTime,
                                  start: startTime,
                                  timeSlots: _con.timeSlots,
                                  checker: (Slots s) {
                                    _con.timeSlots.forEach((element) {
                                      element.checked = false;
                                    });
                                    _con.timeSlots.forEach((element) {
                                      if (element.dateTime == s.displayText) {
                                        element.checked = true;
                                        setState(() {});
                                      }
                                    });
                                  },
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
                                _con.wallet.amount == null
                                    ? "₹ ${0.0}"
                                    : "₹ ${_con.wallet.amount}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                _con.payment = pay.Payment("wallet");
                                slotSelectedChecker()
                                    ? _con.payWithWallet()
                                    : Fluttertoast.showToast(
                                        msg: "Please select time slot");
                                //         msg: 'Not enough balance!');
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
                                // if (deliveryTime == null) {
                                // _onTimePressed();
                                // }
                                // else {
                                slotSelectedChecker()
                                    ? openCheckOut()
                                    : Fluttertoast.showToast(
                                        msg: "Please select time slot");

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
                                _con.payment = pay.Payment("cash");
                                slotSelectedChecker()
                                    ? _con.addOrder(_con.carts)
                                    : Fluttertoast.showToast(
                                        msg: "Please select time slot");

                                // if (deliveryTime == null) {
                                //   _onTimePressed();
                                // } else {
                                //   _handleCoD();
                                // }
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
