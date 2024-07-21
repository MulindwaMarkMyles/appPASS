import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class MenuPage extends StatelessWidget {
  MenuPage({Key? key}) : super(key: key);

  final List<DropdownMenuEntry> dropdownMenuEntries = [
    DropdownMenuEntry(
      label: 'All',
      value: Icons.all_inclusive,
    ),
    DropdownMenuEntry(
      label: "Social",
      value: Ionicons.people_outline,
    ),
    DropdownMenuEntry(
      label: "Finance",
      value: Ionicons.wallet_outline,
    ),
    DropdownMenuEntry(
      label: 'Shopping',
      value: Ionicons.bag_handle_outline,
    ),
    DropdownMenuEntry(
      label: "Work",
      value: Ionicons.briefcase_outline,
    ),
    DropdownMenuEntry(
      label: "Health",
      value: Ionicons.heart_outline,
    ),
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
                'Categories',
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
        Expanded(
          child: ListView.builder(
            itemCount: dropdownMenuEntries.length,
            itemBuilder: (context, index) {
              final entry = dropdownMenuEntries[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Color.fromARGB(255, 252, 171, 134)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        collapsedIconColor: Color.fromARGB(255, 248, 81, 4),
                        iconColor: Color.fromARGB(255, 243, 134, 84),
                        leading: Icon(entry.value),
                        title: Text(entry.label),
                        children: <Widget>[
                          AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text('Option 1'),
                                  onTap: () {
                                  },
                                ),
                                ListTile(
                                  title: Text('Option 2'),
                                  onTap: () {
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


