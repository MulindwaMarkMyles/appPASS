import 'package:flutter/material.dart';
import 'package:app_pass/actions/bottom_bar.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: Center(
        child: Text('Categories'),
      ),
      bottomNavigationBar: BottomNavBar(index: 4),
    );
  }
}