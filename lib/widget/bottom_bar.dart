import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:freshology/screens/cart.dart';
import 'package:freshology/screens/home.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/screens/orders.dart';
import 'package:freshology/screens/wallet.dart';

class HomeParent extends StatefulWidget {
  HomeParent({Key key}) : super(key: key);

  @override
  _HomeParentState createState() => _HomeParentState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _HomeParentState extends State<HomeParent> {
  int _selectedIndex = 1;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Wallet(),
    Home(),
    Orders(),
    Cart()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  customNavigationBarItem(String label, IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Material(
        child: Container(
          height: 50,
          width: 50,
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: _selectedIndex == index ? kLightGreen : Colors.transparent,
              // borderRadius: BorderRadius.all(
              //   Radius.circular(500),
              // ),
              shape: BoxShape.circle),
          child: Column(
            children: [
              Icon(
                icon,
                color: _selectedIndex == index ? Colors.white : Colors.black,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: _selectedIndex == index ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
      label: label,
    );
  }

  customCartButtom(String label, IconData icon, int index) {
    if (_selectedIndex == index) {
      return BottomNavigationBarItem(
        icon: Material(
          child: Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color:
                    _selectedIndex == index ? kLightGreen : Colors.transparent,
                // borderRadius: BorderRadius.all(
                //   Radius.circular(500),
                // ),
                shape: BoxShape.circle),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: _selectedIndex == index ? Colors.white : Colors.black,
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        _selectedIndex == index ? Colors.white : Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
        label: label,
      );
    } else {
      return BottomNavigationBarItem(
        icon: Material(
          child: Container(
            height: 30,
            width: 200,
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              // color: _selectedIndex == index ? kLightGreen : Colors.transparent,
              border: Border.all(
                color: kLightGreen,
                width: 1.5,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Badge(
                  badgeColor: kLightGreen,
                  position: BadgePosition.topEnd(end: -3, top: 0),
                  child: Icon(
                    Icons.shopping_cart,
                    color: kDarkGreen,
                  ),
                  elevation: 0,
                ),
                // Icon(
                //   icon,
                //   size: 18,
                //   color: _selectedIndex == index ? Colors.white : Colors.black,
                // ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "₹ 6786",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
        label: 'Home',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SizedBox(
        height: 65,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0,
          iconSize: 20,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.black,
          items: <BottomNavigationBarItem>[
            customNavigationBarItem("Wallet", Icons.account_balance_wallet, 0),
            customNavigationBarItem("Home", Icons.home, 1),
            customNavigationBarItem("Order", Icons.shopping_basket, 2),
            customCartButtom("Cart", Icons.shopping_cart, 3),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
