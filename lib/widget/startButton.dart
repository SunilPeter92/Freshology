import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';

class StartButton extends StatelessWidget {
  final String name;
  final Function onPressFunc;

  StartButton({
    this.name,
    this.onPressFunc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: RaisedButton(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 0,
        ),
        color: kLightGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: onPressFunc,
        child: Text(
          name,
          style: kStartButtonTextStyle,
        ),
      ),
    );
  }
}
