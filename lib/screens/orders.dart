import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/provider/orderProvider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<OrderProvider>(context, listen: false).orderList.clear();
      Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    var orders = orderProvider.orderList;
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
          inAsyncCall: orderProvider.isLoading,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            child: ListView.builder(
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
                              "Order ID: 232223-2434",
                              style: TextStyle(
                                  color: kDarkGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Date: 08/01/2021",
                              style: TextStyle(
                                  color: kDarkGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Total: ₹286",
                              style: TextStyle(
                                  color: kDarkGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
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
                                    "Order status: ",
                                    style: TextStyle(
                                        color: kDarkGreen,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Delivered",
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
                  // var order = orders[index];

                  // return Container(
                  //   padding: EdgeInsets.symmetric(
                  //     vertical: 10,
                  //     horizontal: 0,
                  //   ),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       orderProvider.selectedIndex = index;
                  //       order.orderStatus.length > 3
                  //           ? null
                  //           : Navigator.pushNamed(context, 'orderDetails');
                  //     },
                  //     child: Card(
                  //       color: kLightGreen,
                  //       elevation: 5,
                  //       child: Padding(
                  //         padding: EdgeInsets.all(8.0),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: <Widget>[
                  //             Text(
                  //               'Order ID : ' + order.orderID,
                  //               style: kOrderPageOrderIDTextStyle,
                  //             ),
                  //             SizedBox(height: 10),
                  //             Text(
                  //               'Date : ' +
                  //                   order.orderTime.toDate().day.toString() +
                  //                   "/" +
                  //                   order.orderTime.toDate().month.toString() +
                  //                   "/" +
                  //                   order.orderTime.toDate().year.toString(),
                  //               style: kOrderPageOrderTimeTextStyle,
                  //             ),
                  //             SizedBox(height: 5),
                  //             Text(
                  //               'Total : ₹ ' + order.orderAmount,
                  //               style: kOrderPageOrderPriceTextStyle,
                  //             ),
                  //             SizedBox(height: 10),
                  //             Container(
                  //               width: MediaQuery.of(context).size.width,
                  //               child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.end,
                  //                 children: <Widget>[
                  //                   Text(
                  //                     'Order Status : ',
                  //                     style: TextStyle(
                  //                       color: kDarkGreen,
                  //                       fontWeight: FontWeight.w600,
                  //                     ),
                  //                   ),
                  //                   order.orderStatus.length > 3
                  //                       ? Text(
                  //                           order.orderStatus,
                  //                           style: TextStyle(
                  //                             color: Colors.red,
                  //                             fontWeight: FontWeight.w600,
                  //                           ),
                  //                         )
                  //                       : order.orderIsComplete
                  //                           ? Text(
                  //                               'Delivered',
                  //                               style: TextStyle(
                  //                                 color: Colors.white,
                  //                                 fontWeight: FontWeight.w600,
                  //                               ),
                  //                             )
                  //                           : Text(
                  //                               'To be delivered',
                  //                               style: TextStyle(
                  //                                 color: kDarkGreen,
                  //                                 fontWeight: FontWeight.w600,
                  //                               ),
                  //                             ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // );
                },
                itemCount: 1),
          ),
        ),
      ),
    );
  }
}
