import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/models/orderModel.dart';
import 'package:freshology/models/userInvoiceModel.dart';
import 'package:freshology/provider/orderProvider.dart';
import 'package:provider/provider.dart';

import 'showInvoice.dart';

class OrderDetails extends StatefulWidget {
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  OrderModel orderItem;
  int orderIndex;
  String amountInWords;
  InvoiceUser userInvoiceDetail;

  @override
  void initState() {
    orderIndex = Provider.of<OrderProvider>(context, listen: false).selectedIndex;
    orderItem = Provider.of<OrderProvider>(context, listen: false).orderList[orderIndex];
    userInvoiceDetail = Provider.of<OrderProvider>(context, listen: false).invoiceUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final index = Provider.of<OrderProvider>(context).selectedIndex;
    final order = Provider.of<OrderProvider>(context).orderList[index];
    String time;
    if (order.orderDeliveryTime == '9') {
      time = "9 AM - 12 PM";
    } else if (order.orderDeliveryTime == '14') {
      time = '2 PM - 5 PM';
    } else {
      time = '6 PM - 9 PM';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: kLightGreen,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(order.orderID),
            SizedBox(height: 20),
            Text('Delivery Time : ' + time),
            SizedBox(height: 10),
            Text(
              'Delivery Date : ' + order.orderDeliveryDate.toDate().day.toString() + "/" + order.orderDeliveryDate.toDate().month.toString() + "/" + order.orderDeliveryDate.toDate().year.toString(),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final item = order.orderItems[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black45,
                      ),
                    ),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(item.name),
                          SizedBox(height: 2),
                          Text(
                            item.weight,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      leading: Text(item.quantity.toString() + ' X '),
                      trailing: Text('₹ ' + item.price),
                    ),
                  );
                },
                itemCount: order.orderItems.length,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: order.orderIsComplete
          ? Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: FloatingActionButton.extended(
                onPressed: () {
                  String url = order.link;
                  print("url" + url);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewerPage(url: url),
                    ),
                  );
                },
                label: Text('Invoice'),
                icon: Icon(Icons.picture_as_pdf),
              ),
            )
          : null,
    );
  }
}
