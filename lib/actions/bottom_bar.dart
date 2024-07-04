import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ionicons/ionicons.dart';

import '/pages/home/home_page.dart';
import '/pages/menu/menu.dart';
import '/pages/build/build.dart';
import '/pages/health/health.dart';
import '/pages/share/share.dart';
import '/pages/settings/settings.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    HomePage(),
    BuildPage(),
    SharePage(),
    HealthPage(),
    MenuPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

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
        children: _screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        height: 70.0,
        index: _page,
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
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
