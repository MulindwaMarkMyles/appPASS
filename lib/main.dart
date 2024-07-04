import 'package:flutter/material.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'pages/splash_screen/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppPass',
      theme: FlutterFlowTheme.themeData,
      home: SplashScreen(),
    );
  }
}
