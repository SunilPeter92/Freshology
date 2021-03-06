import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/controllers/settings_controller.dart';
import 'package:freshology/models/order.dart';
import 'package:freshology/models/userModel.dart';
import 'package:freshology/provider/productProvider.dart';
import 'package:freshology/provider/userProvider.dart';
import 'package:freshology/repositories/appListenables.dart';
import 'package:freshology/widget/CircularLoadingWidget.dart';
import 'package:freshology/widget/OrderWidgetItem.dart';
import 'package:freshology/widget/ProfileSettingsDialog.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends StateMVC<Account> {
  SettingsController _con;

  _AccountState() : super(SettingsController()) {
    _con = controller;
  }

  ScrollController _scrollController;
  String tempProfileImageURL =
      "https://i.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI";
  String tempOrderImageURL =
      "https://firebasestorage.googleapis.com/v0/b/freshology-77c5b.appspot.com/o/fresh%2FVegetables%2Fbaby_onion.jpg?alt=media&token=bf91dba0-7fcb-41f7-8d0d-55197d691998";

  User user;
  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    user = currentUser.value;
    _con.listenForRecentOrders();
    super.initState();
  }

  // orderItemWidget(Order order) {
  //   return Container(
  //     child: Column(
  //       children: [
  //         Container(
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Container(
  //                 child: Image(
  //                   image: NetworkImage(
  //                     tempOrderImageURL,
  //                   ),
  //                   width: 60,
  //                   height: 60,
  //                 ),
  //               ),
  //               Container(
  //                 child: AutoSizeText(
  //                   name,
  //                   maxLines: 1,
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     color: Colors.grey,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.end,
  //                   children: [
  //                     Container(
  //                       child: Text(
  //                         "??? ${amount}",
  //                         style: TextStyle(
  //                           fontSize: 22,
  //                           color: Colors.grey,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     ),
  //                     Container(
  //                       child: Text(
  //                         quantity,
  //                         style: TextStyle(
  //                           fontSize: 12,
  //                           color: Colors.grey,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  recentOrdersCard(String status) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            height: 20,
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Divider(
              color: Colors.grey,
              thickness: 1.5,
            ),
          ),
          SizedBox(height: 20),
          Container(
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "STATUS",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "Order ID: 3423423-34",
                          style: TextStyle(
                            color: kLightGreen,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "??? 678",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "28-01-2021 | 09:03",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "Pay on pickup",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // orderItemWidget("Onions", "45", "500gm"),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Delivery fee",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "??? 20",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TAX ",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "??? 0",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TOTAL ",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "??? 0",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  titleTile(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: kDarkGreen,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: kDarkGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  var _size;
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                iconTheme: IconThemeData(color: Colors.black),
                // leading: Container(),

                title: Text(
                  "Account",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: kDarkGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                elevation: 0,
                backgroundColor: kLightGreen,
                pinned: false,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                centerTitle: true,
              ),
            ];
          },
          body: SingleChildScrollView(
            child: StickyHeader(
              header: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: kLightGreen,
                ),
                child: Container(
                  width: _size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  // color: Colors.blue,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(tempProfileImageURL),
                          radius: 50,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              user.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                          ),
                          ProfileSettingsDialog(
                            user: user,
                            onChanged: () {
                              _con.update(
                                currentUser.value,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              content: Center(
                child: Column(
                  children: <Widget>[
                    // SizedBox(height: 20),
                    // titleTile("ABOUT", Icons.info),
                    // Container(
                    //   padding: EdgeInsets.all(8),
                    //   child: Text(
                    //     "${user.bio}",
                    //     style: TextStyle(
                    //       color: Colors.grey,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 20),
                    titleTile("RECENT ORDERS", Icons.shopping_basket),
                    // recentOrdersCard("Cancelled"),
                    // recentOrdersCard("Delivered"),
                    _con.recentOrders.isEmpty
                        ? CircularLoadingWidget(height: 200)
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: _con.recentOrders.length,
                            itemBuilder: (context, index) {
                              return ExpansionTile(
                                initiallyExpanded: true,
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                            'Order ID: #${_con.recentOrders.elementAt(index).id}')),
                                    Text(
                                      '${_con.recentOrders.elementAt(index).orderStatus.status}',
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ],
                                ),
                                children: List.generate(
                                    _con.recentOrders
                                        .elementAt(index)
                                        .productOrders
                                        .length, (indexFood) {
                                  return OrderItemWidget(
                                      heroTag: 'recent_orders',
                                      order: _con.recentOrders.elementAt(index),
                                      foodOrder: _con.recentOrders
                                          .elementAt(index)
                                          .productOrders
                                          .elementAt(indexFood));
                                }),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
