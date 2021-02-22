import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/models/userModel.dart';
import 'package:freshology/repositories/user_repository.dart' as repo;

class AnimatedSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  FirebaseAuth _auth = FirebaseAuth.instance;

  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    UserModel user = await repo.getCurrentUser();
    print(user.toMap());
    // FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      Navigator.pushNamed(context, 'home');
    } else {
      Navigator.pushNamed(context, 'start');
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 1));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();
    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteBackground,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/logo_text.png',
                  width: animation.value * 250,
                  height: animation.value * 250,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
