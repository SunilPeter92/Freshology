import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/functions/stringExtension.dart';
import 'package:freshology/models/orderModel.dart';
import 'package:freshology/models/userInvoiceModel.dart';
import 'package:freshology/provider/orderProvider.dart';
import 'package:freshology/provider/promoProvider.dart';
import 'package:freshology/provider/userProvider.dart';
import 'package:freshology/widget/startButton.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:number_to_words_spelling/number_to_words_spelling.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

class OrderConfirm extends StatefulWidget {
  @override
  _OrderConfirmState createState() => _OrderConfirmState();
}

class _OrderConfirmState extends State<OrderConfirm> {
  final pdf = pw.Document();
  OrderModel orderItem;
  double taxAmount = 0;
  double totalTax = 0;
  double subTotal = 0;
  double value = 0;
  int deliveryCharge = 30;
  String amountInWords;
  InvoiceUser userInvoiceDetail;
  bool _isSaving = true;
  Firestore _db = Firestore.instance;
  OrderProductModel withFee = OrderProductModel(
    name: 'Delivery Charge',
    weight: '',
    price: '30',
    quantity: 1,
    cGST: 9,
    hSN: '00000000',
    iGST: 18,
    sGST: 9,
    sKU: '',
  );
  OrderProductModel withoutFee = OrderProductModel(
    name: 'Delivery Charge',
    weight: '',
    price: '0',
    quantity: 1,
    cGST: 9,
    hSN: '00000000',
    iGST: 18,
    sGST: 9,
    sKU: '',
  );

  Future<void> getOrderItem() async {
    String orderID = Provider.of<OrderProvider>(context, listen: false).savedOrderID;
    var item = await _db.collection('orders').document(orderID).get();
    List<OrderProductModel> orderItemsList = [];
    orderItemsList.clear();
    var items = await _db.collection('orders').document(orderID).collection('items').getDocuments();
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
    if (item.data['delivery_charge']) {
      orderItemsList.add(withFee);
    } else {
      orderItemsList.add(withoutFee);
    }
    orderItem = OrderModel(
      orderStatus: item.data['order_status'],
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
    );
  }

  @override
  void initState() {
    deliveryCharge = Provider.of<PromoProvider>(context, listen: false).deliveryCharge;
    if (deliveryCharge != 30) {
      setState(() {
        withFee.price = deliveryCharge.toString();
      });
    }
    Future.delayed(Duration.zero, () async {
//      await Provider.of<OrderProvider>(context, listen: false).fetchOrders();
//      var orderList =
//          Provider.of<OrderProvider>(context, listen: false).orderList;
//      orderItem = orderList[0];
      await getOrderItem();
      userInvoiceDetail = Provider.of<OrderProvider>(context, listen: false).invoiceUser;
      amountInWords = NumberWordsSpelling.toWord(orderItem.orderAmount, 'en_US');
      await createPdf();
    });
    super.initState();
  }

  Future<void> createPdf() async {
    await savePdf();
  }

  double originalValue(double c, double s, double i, int price, int q) {
    setState(() {
      value = price / (1 + i / 100);
      taxAmount = (price - value) * q;
      totalTax = totalTax + taxAmount;
      subTotal = subTotal + (price * q);
    });
    return value;
  }

  writeOnPdf() {
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),
        build: (pw.Context context) => [
          pw.Column(
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    children: [
                      pw.Text(
                        'Freshology',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      pw.Text(
                        'A unit of Infinity Trade Inc.',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      pw.Text(
                        'Regd. Add. 1G-43 B.P.',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      pw.Text(
                        '3rd Floor, Unit no. 1',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      pw.Text(
                        'N.I.T.',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      pw.Text(
                        'Faridabad, Haryana - 121001',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      pw.SizedBox(
                        height: 20,
                      ),
                      pw.Row(children: [
                        pw.Text(
                          'PAN No: ',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        pw.Text(
                          'FPBPS1570E',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ]),
                      pw.Row(children: [
                        pw.Text(
                          'GST Registration No: ',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        pw.Text(
                          '06FPBPS1570E2ZY',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ]),
                      pw.SizedBox(
                        height: 20,
                      ),
                      pw.Row(children: [
                        pw.Text(
                          'Place of Supply: ',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        pw.Text(
                          'Haryana',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ]),
                      pw.Row(children: [
                        pw.Text(
                          'Place of Delivery: ',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        pw.Text(
                          'Haryana',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ]),
                      pw.SizedBox(
                        height: 20,
                      ),
                      pw.Row(children: [
                        pw.Text(
                          'Invoice number : ',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        pw.Text(
                          orderItem.invoiceId,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ]),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Row(children: [
                        pw.Text(
                          'Order ID : ',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        pw.Text(
                          orderItem.orderID,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ]),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Row(children: [
                        pw.Text(
                          'Invoice date : ',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        pw.Text(
                          '${orderItem.orderDeliveryDate.toDate().day} / ${orderItem.orderDeliveryDate.toDate().month} / ${orderItem.orderDeliveryDate.toDate().year}',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ]),
                      pw.SizedBox(
                        height: 40,
                      ),
                    ],
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                  ),
                  pw.Column(
                    children: [
                      pw.Text(
                        'Tax Invoice/Bill of Supply/Cash Memo',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      pw.Text(
                        '(Original For Recipient)',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      pw.SizedBox(
                        height: 20,
                      ),
                      pw.Text(
                        'Customer Name :',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      pw.Text(
                        userInvoiceDetail.name,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      pw.SizedBox(
                        height: 20,
                      ),
                      pw.Text(
                        'Customer Phone No :',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      pw.Text(
                        userInvoiceDetail.phone,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      pw.SizedBox(
                        height: 20,
                      ),
                      pw.Text(
                        'Shipping/Billing Address :',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      pw.SizedBox(
                        width: 200,
                        child: pw.Text(
                          userInvoiceDetail.address,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 14,
                          ),
                          softWrap: true,
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                      pw.SizedBox(
                        height: 40,
                      ),
                    ],
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                  ),
                ],
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              ),
            ],
          ),
          pw.Table.fromTextArray(
            context: context,
            data: <List<String>>[
              <String>[
                'S. No.',
                'Description',
                'Unit Price',
                'Qty./ Unit',
                'Net Amount',
                'C GST',
                'S GST',
                'Tax Amount',
                'Total Amount',
              ],
              ...orderItem.orderItems.map((item) => [
                    item.name == 'Delivery Charge' ? '' : (orderItem.orderItems.indexOf(item) + 1).toString(),
                    item.name +
                        ' (Unit : ' +
                        item.weight +
                        ' )' +
                        ' ( SKU '
                            ':' +
                        item.sKU +
                        ') ' +
                        ' (HSN/SAC : ' +
                        item.hSN +
                        ' )',
                    originalValue(
                      item.cGST,
                      item.sGST,
                      item.iGST,
                      int.parse(item.price),
                      item.quantity,
                    ).toStringAsFixed(2),
                    item.quantity.toString(),
                    (value * item.quantity).toStringAsFixed(2),
                    item.cGST.toString() + ' %',
                    item.sGST.toString() + ' %',
                    taxAmount.toStringAsFixed(2),
                    (int.parse(item.price) * item.quantity).toStringAsFixed(2),
                  ])
            ],
          ),
          pw.Column(children: [
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.SizedBox(height: 20),
                pw.Text(
                  'Total Tax : ',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                pw.Text(
                  'Rs ${totalTax.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Amount in Words : ',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                pw.Text(
                  capitalize(amountInWords) + ' only',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Payment Info : ',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                pw.Text(
                  orderItem.orderPaymentMethod,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ]),
              pw.Row(children: [
                pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Total amount : ',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  pw.Text(
                    'Discount : ',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  pw.Text(
                    'Net Payable/Paid : ',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ]),
                pw.SizedBox(width: 10),
                pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Rs ${subTotal.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  pw.Text(
                    '- Rs ${orderItem.discount.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  pw.Text(
                    'Rs ${int.parse(orderItem.orderAmount).toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ]),
              ]),
            ]),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(
                  height: 20,
                ),
                pw.Text(
                  'This is a computer-generated invoice and does not require Signature.',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                pw.Text(
                  'Whether tax is payable under reverse charge - No ',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ]),
        ],
      ),
    );
  }

  Future savePdf() async {
    await writeOnPdf();
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/invoice_${orderItem.orderID}.pdf");
    file.writeAsBytesSync(pdf.save());
    savePdfCloud(file.readAsBytesSync(), 'invoice_${orderItem.orderID}');
  }

  Future<void> savePdfCloud(List<int> asset, String name) async {
    StorageReference reference = FirebaseStorage.instance.ref().child(name);
    StorageUploadTask uploadTask = reference.putData(asset);
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    String orderID = Provider.of<OrderProvider>(context, listen: false).savedOrderID;
    String userDocId = Provider.of<UserProvider>(context, listen: false).userDocID;
    await _db.collection('user').document(userDocId).collection('orders').document(orderID).updateData({
      'invoice_link': url,
    });
    setState(() {
      _isSaving = false;
    });
    print(url);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ModalProgressHUD(
        inAsyncCall: _isSaving,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Order Confirmation'),
            backgroundColor: kLightGreen,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pushNamed(context, 'home'),
            ),
          ),
          body: _isSaving
              ? Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 20,
                  ),
                  child: Text(
                    'Saving your order, please wait. Do not close the app.',
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.black45,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 20,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'Thank You. Your order has been confirmed.',
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.black45,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Image(
                        image: AssetImage('assets/orderConfirm.png'),
                      ),
                      StartButton(
                        name: 'My Orders',
                        onPressFunc: () {
                          Navigator.pushNamed(context, 'orders');
                        },
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
