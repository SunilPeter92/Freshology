import 'package:flutter/material.dart';
import 'package:freshology/repositories/appListenables.dart';
import 'package:freshology/repositories/favorite_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/favorite.dart';

class FavoriteController extends ControllerMVC {
  List<Favorite> favorites = <Favorite>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  FavoriteController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForFavorites({String message}) async {
    if (currentUser.value.apiToken != null) {
      final Stream<Favorite> stream = await getFavorites();
      stream.listen((Favorite _favorite) {
        setState(() {
          favorites.add(_favorite);
        });
      }, onError: (a) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Verify your internet connection"),
        ));
      }, onDone: () {
        if (message != null) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(message),
          ));
        }
      });
    }
  }

  Future<void> refreshFavorites() async {
    favorites.clear();
    listenForFavorites(message: 'Favorites refreshed successfuly');
  }
}
