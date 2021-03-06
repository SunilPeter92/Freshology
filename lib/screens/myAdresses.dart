import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/models/Address.dart';
import 'package:freshology/models/userModel.dart';
import 'package:freshology/provider/userProvider.dart';
import 'package:freshology/repositories/user_repository.dart';
import 'package:freshology/widget/startButton.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import '../repositories/appListenables.dart';

class Addresses extends StatefulWidget {
  @override
  _AddressesState createState() => _AddressesState();
}

List<Address> addresses = [];

class _AddressesState extends State<Addresses> {
  User user;
  @override
  void initState() {
    user = currentUser.value;
    initializeData();
    super.initState();
  }

  initializeData() {
    addresses.add(Address(
      country: "India",
      countryId: "1",
      state: "Haryana",
      stateId: "23",
      city: "Faridabad",
      cityId: "3",
      area: "charmwood",
      areaId: "32",
      houseNo: "abc xyz 123, abc 123, xyz",
    ));
    addresses.add(Address(
      country: "India",
      countryId: "1",
      state: "Haryana",
      stateId: "23",
      city: "Faridabad",
      cityId: "3",
      area: "charmwood",
      areaId: "32",
      houseNo: "abc xyz 123, abc 123, xyz",
    ));
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, 'address');
        },
        child: Icon(
          Icons.add,
          color: kDarkGreen,
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: kDarkGreen),
        title: Text(
          'Address',
          style: TextStyle(
            color: kDarkGreen,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ModalProgressHUD(
        inAsyncCall: false,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          child: Container(
            child: ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    elevation: 4.0,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  addresses[index].country,
                                  style: TextStyle(
                                    color: kDarkGreen,
                                  ),
                                ),
                                Text(
                                  addresses[index].state,
                                  style: TextStyle(
                                    color: kDarkGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            child: Text(
                              "${addresses[index].houseNo}+${addresses[index].area}",
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            child: Text(
                              "${addresses[index].city}",
                            ),
                          ),
                          SizedBox(height: 5),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, 'address');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // Container(child:),
                        ],
                      ),
                    ),
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
