import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '/pages/home/home_page.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _page = index;
          });
        },
        children: <Widget>[
          HomeScreen(),
          BuildScreen(),
          ShareScreen(),
          HeartScreen(),
          MenuScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        height: 70.0,
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
            _pageController.animateToPage(index, duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

class BuildScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Build Screen'));
  }
}

class ShareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Share Screen'));
  }
}

class HeartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Heart Screen'));
  }
}

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Menu Screen'));
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Settings Screen'));
  }
}
