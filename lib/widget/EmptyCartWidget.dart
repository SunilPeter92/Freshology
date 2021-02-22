import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:foodish_application/config/app_config.dart' as config;

class EmptyCartWidget extends StatefulWidget {
  EmptyCartWidget({
    Key key,
  }) : super(key: key);

  @override
  _EmptyCartWidgetState createState() => _EmptyCartWidgetState();
}

class _EmptyCartWidgetState extends State<EmptyCartWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: AlignmentDirectional.center,
          padding: EdgeInsets.symmetric(horizontal: 30),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Theme.of(context).focusColor.withOpacity(0.7),
                              Theme.of(context).focusColor.withOpacity(0.05),
                            ])),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      size: 70,
                    ),
                  ),
                  Positioned(
                    right: -30,
                    bottom: -50,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -20,
                    top: -50,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 15),
              Opacity(
                opacity: 0.4,
                child: Text(
                  'D\'ont have any item in your cart',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 50),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'home');
                },
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                color: Theme.of(context).accentColor.withOpacity(1),
                shape: StadiumBorder(),
                child: Text(
                  'Start Exploring',
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
