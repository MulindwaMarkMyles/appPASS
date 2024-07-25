import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatelessWidget {
  final List<Category> categories = [
    Category('All', 100, Ionicons.key_outline),
    Category('Passkeys', 20, Ionicons.person_outline),
    Category('Codes', 15, Ionicons.lock_closed_outline),
    Category('Wi-Fi', 25, Ionicons.wifi_outline),
    Category('Security', 10, Ionicons.alert_circle_outline),
    Category('Deleted', 5, Ionicons.trash_bin_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/Image1.png',
              width: 40,
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              'Home',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                // Handle search logic if needed
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Ionicons.search_outline, color: Color.fromARGB(255, 243, 134, 84)),
                hintText: 'Search',
                hintStyle: TextStyle(color: const Color.fromARGB(255, 9, 3, 3)),
                filled: true,
                fillColor: Color.fromRGBO(246, 208, 183, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1, // Adjust aspect ratio to fit better
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  title: category.title,
                  count: category.count,
                  icon: category.icon,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        // ignore: sort_child_properties_last
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Ionicons.add_circle_outline,
              color:  Color.fromARGB(255, 243, 117, 59),
              size: 30,
            ),
          ),
        ),
        color: Color.fromARGB(255, 243, 220, 205),
      ),
      backgroundColor: Color.fromARGB(255, 243, 220, 205),
    );
  }
}

class Category {
  final String title;
  final int count;
  final IconData icon;

  Category(this.title, this.count, this.icon);
}

class CategoryCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.count,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 243, 220, 205), // Match the Scaffold background color
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color.fromARGB(255, 243, 117, 59), width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Avoid overflow
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: const Color.fromARGB(255, 21, 16, 8)), // Adjust icon size
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 243, 117, 59)), // Adjust text size
              textAlign: TextAlign.center, // Center align text
            ),
            SizedBox(height: 5),
            Text(
              count.toString(),
              style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 16, 13, 9)), // Adjust text size
            ),
          ],
        ),
      ),
    );
  }
}
