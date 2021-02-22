import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/widget/startButton.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Are you sure?',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              content: Text(
                'Do you want to exit the app',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('YES'),
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Container(
          color: kWhiteBackground,
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: size.width * 0.8,
                child: Hero(
                  tag: 'logo',
                  child: Image(
                    image: AssetImage('assets/logo_main.png'),
                    width: 300,
                    height: 200,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 80,
              ),
              StartButton(
                name: 'New Customer',
                onPressFunc: () {
                  Navigator.pushNamed(context, 'register');
                },
              ),
              SizedBox(
                height: 20,
              ),
              StartButton(
                name: 'Existing Customer',
                onPressFunc: () {
                  Navigator.pushNamed(context, 'login');
                },
              ),
              SizedBox(
                height: 80,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'home');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 5,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 2,
                        color: kDarkGreen,
                      ),
                    ),
                  ),
                  child: Text(
                    'Explore as Guest',
                    style: TextStyle(
                      color: kDarkGreen,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
