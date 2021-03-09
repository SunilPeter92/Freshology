import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:animated_radio_buttons/animated_radio_buttons.dart';

class CustomDialogBox extends StatefulWidget {
  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  List<AnimatedRadioButtonItem> _radioButtons = [];

  List<String> _subscriptionList = [
    "1 Month",
    "2 Month",
    "3 Month",
  ];
  TextEditingController _controller;
  subscriptionTilesWidget(
    String month,
  ) {
    return Container(
      padding: EdgeInsets.all(8),
      width: 65,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: _controller.text == month ? kLightGreen : kDarkGreen,
        ),
        borderRadius: BorderRadius.circular(15),
        color: _controller.text == month ? Colors.white : kLightGreen,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _controller.text = month;
          });
        },
        child: Column(
          children: [
            Text(
              "${month}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _controller.text == month ? Colors.black : Colors.white,
              ),
            ),
            Text(
              "Month",
              style: TextStyle(
                fontSize: 12,
                color: _controller.text == month ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _generateRadioList() {
    int i = 0;
    for (i = 0; i < _subscriptionList.length; i++) {
      _radioButtons.add(
        AnimatedRadioButtonItem(
          label: _subscriptionList[i].toString(),
          color: kLightGreen,
          fillInColor: Colors.white,
        ),
      );
    }
  }

  var size;
  @override
  void initState() {
    // TODO: implement initState
    _controller = TextEditingController();
    _generateRadioList();

    super.initState();
  }

  var myVar;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.padding),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: contentBox(context),
      ),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(Constants.padding),
          child: Container(
            height: size.height * 0.8,
            width: size.width * 0.9,
            margin: EdgeInsets.only(top: Constants.avatarRadius),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Constants.padding),
              child: Image(
                image: AssetImage('assets/modal_background.jpg'),
                color: Colors.black.withOpacity(0.6),
                colorBlendMode: BlendMode.multiply,
                fit: BoxFit.cover,
              ),
            ),
            decoration: BoxDecoration(
                color: kDarkGreen.withOpacity(0.5),
                borderRadius: BorderRadius.circular(Constants.padding),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0, 8),
                      blurRadius: 10),
                ]),
          ),
        ),
        Container(
          height: size.height * 0.8,
          width: size.width * 0.9,
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                "VIP MEMBERSHIP",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Container(
                height: size.height * 0.4,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Column(
                  children: [
                    Text(
                      "Select your package",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50),
                    Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        subscriptionTilesWidget("1"),
                        subscriptionTilesWidget("2"),
                        subscriptionTilesWidget("3"),
                      ],
                    )),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: FlatButton(
                  padding: EdgeInsets.all(14),
                  color: kLightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Add to cart",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Image.asset("assets/vip.png")),
          ),
        ),
      ],
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 15;
  static const double avatarRadius = 45;
}
