import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  final List<SettingsSection> settingsSections = [
    SettingsSection(
      title: 'Account Settings',
      icon: Ionicons.person_outline,
      settingsOptions: [
        SettingsOption(
          label: 'Profile',
          helpText: 'Manage your profile settings',
          icon: Ionicons.person_outline,
        ),
        SettingsOption(
          label: 'Change Password',
          helpText: 'Update your password',
          icon: Ionicons.lock_closed_outline,
        ),
        SettingsOption(
          label: 'Language',
          helpText: 'Set your preferred language',
          icon: Ionicons.language_outline,
        ),
      ],
    ),
    SettingsSection(
      title: 'Notifications',
      icon: Ionicons.notifications_outline,
      settingsOptions: [
        SettingsOption(
          label: 'Email Notifications',
          helpText: 'Receive notifications via email',
          icon: Ionicons.mail_outline,
        ),
        SettingsOption(
          label: 'Push Notifications',
          helpText: 'Receive push notifications',
          icon: Ionicons.notifications_outline,
        ),
        SettingsOption(
          label: 'SMS Notifications',
          helpText: 'Receive notifications via SMS',
          icon: Ionicons.chatbubble_ellipses_outline,
        ),
      ],
    ),
    SettingsSection(
      title: 'Privacy',
      icon: Ionicons.lock_closed_outline,
      settingsOptions: [
        SettingsOption(
          label: 'Blocked Accounts',
          helpText: 'Manage blocked accounts',
          icon: Ionicons.person_remove_outline,
        ),
        SettingsOption(
          label: 'Privacy Policy',
          helpText: 'View our privacy policy',
          icon: Ionicons.document_text_outline,
        ),
        SettingsOption(
          label: 'Terms of Service',
          helpText: 'Read our terms of service',
          icon: Ionicons.document_attach_outline,
        ),
      ],
    ),
    SettingsSection(
      title: 'About',
      icon: Ionicons.information_circle_outline,
      settingsOptions: [
        SettingsOption(
          label: 'About Us',
          helpText: 'Learn more about us',
          icon: Ionicons.information_circle_outline,
        ),
        SettingsOption(
          label: 'App Version',
          helpText: 'Check the app version',
          icon: Ionicons.phone_portrait_outline,
        ),
        SettingsOption(
          label: 'Contact Us',
          helpText: 'Get in touch with us',
          icon: Ionicons.mail_open_outline,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
<<<<<<< HEAD
          title: Text(
            'Settings',
            style: TextStyle(
              fontFamily: GoogleFonts.getFont('Poppins').fontFamily ?? '',
              color: Color.fromARGB(255, 243, 134, 84),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
=======
          title: Row(
            children: [
              Image.asset(
                'assets/Image1.png',
                width: 40, // Adjust size as needed
                height: 40, // Adjust size as needed
              ),
              SizedBox(width: 10), // Adjust spacing between logo and title
              Text(
                'Settings',
                style: TextStyle(
                  fontFamily: GoogleFonts.getFont('Poppins').fontFamily,
                  color: Color.fromARGB(255, 243, 134, 84),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
>>>>>>> ayman
          ),
          backgroundColor: Color.fromRGBO(246, 208, 183, 1),
        ),
        Expanded(
<<<<<<< HEAD
          child: ListView.builder(
            itemCount: settingsSections.length,
            itemBuilder: (context, index) {
              final section = settingsSections[index];
              return Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Color.fromARGB(255, 252, 171, 134)))),
                child: ExpansionTile(
                  collapsedIconColor: Color.fromARGB(255, 248, 81, 4),
                  iconColor: Color.fromARGB(255, 243, 134, 84),
                  leading: Icon(section.icon),
                  title: Text(section.title),
                  children: section.settingsOptions.map((option) {
                    return ListTile(
                      leading: Icon(option.icon),
                      title: Text(option.label),
                      subtitle: Text(option.helpText),
                      onTap: () {
                        print('Selected ${option.label}');
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Ionicons.logo_facebook,
                    color: Color.fromARGB(255, 243, 134, 84)),
                onPressed: () {
                  print('Facebook');
                },
              ),
              IconButton(
                icon: Icon(Ionicons.logo_twitter,
                    color: Color.fromARGB(255, 243, 134, 84)),
                onPressed: () {
                  print('Twitter');
                },
              ),
              IconButton(
                icon: Icon(Ionicons.logo_instagram,
                    color: Color.fromARGB(255, 243, 134, 84)),
                onPressed: () {
                  print('Instagram');
                },
              ),
            ],
=======
          child: Center(
            child: Text('Build Screen'),
>>>>>>> ayman
          ),
        ),
      ],
    );
  }
}
<<<<<<< HEAD

class SettingsSection {
  final String title;
  final IconData icon;
  final List<SettingsOption> settingsOptions;

  SettingsSection({
    required this.title,
    required this.icon,
    required this.settingsOptions,
  });
}

class SettingsOption {
  final String label;
  final String helpText;
  final IconData icon;

  SettingsOption({
    required this.label,
    required this.helpText,
    required this.icon,
  });
}
=======
>>>>>>> ayman
