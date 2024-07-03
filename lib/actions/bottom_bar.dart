import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  PageController _pageController = PageController();

  final List<String> _titles = [
    'Home',
    'Build',
    'Share',
    'Heart',
    'Menu',
    'Settings'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: _titles[_page]),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _page = index;
          });
        },
        children: <Widget>[
          MyHomePage(title: _titles[0]),      // Replace with your custom home screen
          MyBuildPage(title: _titles[1]),     // Replace with your custom build screen
          MySharePage(title: _titles[2]),     // Replace with your custom share screen
          MyHeartPage(title: _titles[3]),     // Replace with your custom heart screen
          MyMenuPage(title: _titles[4]),      // Replace with your custom menu screen
          MySettingsPage(title: _titles[5]),  // Replace with your custom settings screen
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

// Custom AppBar widget with a logo
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/Image1.png', 
            height: 30,
          ),
          SizedBox(width: 10),
          Text(title),
        ],
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// Replace these placeholder classes with your actual custom screens

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/Image1.png', height: 100),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Center(child: Text('Home Screen')),
      ],
    );
  }
}

class MyBuildPage extends StatelessWidget {
  final String title;

  MyBuildPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/Image1.png', height: 100),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Center(child: Text('Build Screen')),
      ],
    );
  }
}

class MySharePage extends StatelessWidget {
  final String title;

  MySharePage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/Image1.png', height: 100),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Center(child: Text('Share Screen')),
      ],
    );
  }
}

class MyHeartPage extends StatelessWidget {
  final String title;

  MyHeartPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/Image1.png', height: 100),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Center(child: Text('Heart Screen')),
      ],
    );
  }
}

class MyMenuPage extends StatelessWidget {
  final String title;

  MyMenuPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/Image1.png', height: 100),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Center(child: Text('Menu Screen')),
      ],
    );
  }
}

class MySettingsPage extends StatelessWidget {
  final String title;

  MySettingsPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/Image1.png', height: 100),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Center(child: Text('Settings Screen')),
      ],
    );
  }
}
