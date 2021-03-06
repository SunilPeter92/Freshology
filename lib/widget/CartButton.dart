import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:badges/badges.dart';
import 'package:freshology/provider/cartProvider.dart';
import 'package:freshology/repositories/appListenables.dart';
import 'package:provider/provider.dart';

class CartButton extends StatefulWidget {
  double cartTotal;
  CartButton({@required this.cartTotal});
  @override
  _CartButtonState createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  @override
  Widget build(BuildContext context) {
    widget.cartTotal == null ? widget.cartTotal = 0.0 : null;
    final cartProvider = Provider.of<CartProvider>(context);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'cart');
      },
      child: Container(
        width: 85,
        margin: EdgeInsets.only(right: 10, top: 10),
        decoration: BoxDecoration(
            border: Border.all(
              color: kLightGreen,
              width: 1.5,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
            color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Badge(
              badgeColor: kLightGreen,
              position: BadgePosition.topEnd(end: -3, top: 0),
              showBadge: cartProvider.itemCount > 0 ? true : false,
              child: Icon(
                Icons.shopping_cart,
                color: kDarkGreen,
              ),
              elevation: 0,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "₹ " + widget.cartTotal.toStringAsFixed(1),
              // (cartProvider.totalValue == null
              //     ? "${val}"
              //     : cartProvider.totalValue.toString()),
              style: TextStyle(
                fontSize: 11,
                color: Colors.black,
              ),
            ),
            // ValueListenableBuilder(
            //   builder: (context, val, child) {
            //     return Text(
            //       "₹ " + val.toStringAsFixed(1),
            //       // (cartProvider.totalValue == null
            //       //     ? "${val}"
            //       //     : cartProvider.totalValue.toString()),
            //       style: TextStyle(
            //         fontSize: 11,
            //         color: Colors.black,
            //       ),
            //     );
            //   },
            //   valueListenable: cartValue,
            // ),
          ],
        ),
      ),
    );
  }
}
