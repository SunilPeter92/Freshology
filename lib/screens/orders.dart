import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/controllers/order_controller.dart';
import 'package:freshology/provider/orderProvider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends StateMVC<Orders> {
  OrderController _con;

  _OrdersState() : super(OrderController()) {
    _con = controller;
  }
  @override
  void initState() {
    _con.listenForOrders();
    // Future.delayed(Duration.zero, () {
    //   Provider.of<OrderProvider>(context, listen: false).orderList.clear();
    //   Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderProvider = Provider.of<OrderProvider>(context);
    // var orders = orderProvider.orderList;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: kDarkGreen),
          title: Text(
            'Order History',
            style: TextStyle(
              color: kDarkGreen,
            ),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Navigator.pushNamed(context, 'home'),
          ),
          // actions: <Widget>[
          //   GestureDetector(
          //     onTap: () {
          //       Navigator.pushNamed(context, 'refund');
          //     },
          //     child: Icon(FontAwesomeIcons.questionCircle),
          //   ),
          //   SizedBox(width: 20),
          // ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: _con.isLoading,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            child: _con.isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _con.orders.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: kLightGreen,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Order ID: ${_con.orders[index].id}",
                                  style: TextStyle(
                                      color: kDarkGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Date: " +
                                      "${_con.orders[index].dateTime.day} / " +
                                      "${_con.orders[index].dateTime.month} / " +
                                      "${_con.orders[index].dateTime.year}",
                                  style: TextStyle(
                                      color: kDarkGreen,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(height: 5),
                                // Text(
                                //   "Total: ${_con.orders[index].}",
                                //   style: TextStyle(
                                //       color: kDarkGreen,
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 16),
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Order status",
                                        style: TextStyle(
                                            color: kDarkGreen,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        " ${_con.orders[index].orderStatus.status}",
                                        style: TextStyle(
                                            color: kLightGreen,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
