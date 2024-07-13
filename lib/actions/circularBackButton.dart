import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Circularbackbutton extends StatelessWidget {
  final Function() onPressed;
  
  const Circularbackbutton({required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed, 
      icon: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(Ionicons.arrow_back_circle, color: Colors.black),
      ));
  }
}