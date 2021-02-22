import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';

class Refund extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightGreen,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 15,
          ),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                'Refund Policy',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'We have a "no questions asked return and refund policy" '
                'which entitles all our members to return the product at '
                'the time of delivery if due to some reason they are not satisfied with the quality or freshness of the product. We will take the returned product back with us and issue a credit note for the value of the return products which will be credited to your account on the Site. This can be used to pay your subsequent shopping bills.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
