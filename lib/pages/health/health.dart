import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
class HealthPage extends StatelessWidget {
  HealthPage({Key? key}) : super(key: key);
  final List<Map> healthData = [
    {
      'title': 'Google',
      'strength': 90,
      'description': 'Your password is strong, but resused on other sites.',
      'icon': Ionicons.checkmark_circle_outline,
      'color': Colors.green,
    },
    {
      'title': 'Facebook',
      'strength': 30,
      'description': 'Your password is weak and resused on other sites.',	
      'icon': Ionicons.warning_outline,
      'color': Colors.red,
    },
    {
      'title': 'Instagram',
      'strength': 50,
      'description': 'Your password is fair.',
      'icon': Ionicons.warning_outline,
      'color': Colors.orange,
    },
    {
      'title': 'Muele',
      'strength': 60,
      'description': 'Your password is fair.',
      'icon': Ionicons.checkmark_circle_outline,
      'color': Colors.yellow[600],
    },
    {
      'title': 'Spotify',
      'strength': 75,
      'description': 'Your password is strong, but resused on other sites.',	
      'icon': Ionicons.checkmark_circle_outline,
      'color': Colors.green[400],
    },
    
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/Image1.png',
                width: 40, // Adjust size as needed
                height: 40, // Adjust size as needed
              ),
              SizedBox(width: 10), // Adjust spacing between logo and title
              Text(
                'Password Health',
                style: TextStyle(
                  fontFamily: GoogleFonts.getFont('Poppins').fontFamily,
                  color: Color.fromARGB(255, 243, 134, 84),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          backgroundColor: Color.fromRGBO(246, 208, 183, 1),
        ),
        SizedBox(height: 40),
        Text("Compromised passwords", style: TextStyle(fontSize: 20, fontFamily: GoogleFonts.getFont('Poppins').fontFamily, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: healthData.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(
                  healthData[index]['icon'],
                  color: healthData[index]['color'],
                ),
                title: Text(healthData[index]['title']),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    LinearProgressIndicator(
                    value: healthData[index]['strength'] / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      healthData[index]['color'],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(healthData[index]['description']),
                  ],
                ),
              );
            },
        ),
     ),
    
     ],
    );
  }
}
