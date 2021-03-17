import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/widget/startButton.dart';

void showNoUserModal(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 40,
          ),
          height: MediaQuery.of(context).size.height * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Hey Guest!',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: kDarkGreen,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Please sign up '
                  'before adding items in the '
                  'cart.',
                  textAlign: TextAlign.start,
                ),
              ),
              StartButton(
                name: 'Sign Up',
                onPressFunc: () {
                  Navigator.pushNamed(context, 'start');
                },
              ),
            ],
          ),
        );
      });
}
