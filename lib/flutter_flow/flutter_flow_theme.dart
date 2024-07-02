import 'package:flutter/material.dart';

class FlutterFlowTheme {
  static ThemeData get themeData {
    return ThemeData(
      primarySwatch: Colors.deepOrange,
      scaffoldBackgroundColor: Color.fromARGB(255, 243, 220, 205),
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        color: Color.fromARGB(255, 248, 204, 174),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
          ),
        )
    );
  }
}
