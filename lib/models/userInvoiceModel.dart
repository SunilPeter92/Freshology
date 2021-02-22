import 'package:flutter/cupertino.dart';

class InvoiceUser {
  String name;
  String phone;
  String address;
  String state;

  InvoiceUser({
    this.name,
    this.phone,
    this.address,
    @required this.state,
  });
}
