import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      height: 60.0,
      index: 0,
      items: <Widget>[
        Icon(Ionicons.home_outline, size: 30),
        Icon(Ionicons.build_outline, size: 30),
        Icon(Ionicons.share_social_outline, size: 30),
        Icon(Ionicons.heart_half_outline, size: 30),
        Icon(Ionicons.menu_outline, size: 30),
        Icon(Ionicons.settings_outline, size: 30),
      ],
      color: Color.fromRGBO(252, 231, 217, 1),
      buttonBackgroundColor: Colors.deepOrange[200],
      backgroundColor: Color.fromARGB(255, 243, 220, 205),
      animationCurve: Curves.easeInOut,
      animationDuration: Duration(milliseconds: 400),
      onTap: (index) {
        setState(() {
          _page = index;
        });
      },
      letIndexChange: (index) => true,
    );
  }
}
