import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:app_pass/authentication/login_or_signup.dart';
import 'package:app_pass/services/auth.dart';
import 'package:app_pass/authentication/password_reset_screen.dart'; // Import the password reset screen

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  final List<SettingsSection> settingsSections = [
    SettingsSection(
      title: 'Account Settings',
      icon: Ionicons.person_outline,
      settingsOptions: [
        SettingsOption(
          key: 'profile',
          label: 'Profile',
          helpText: 'Manage your profile settings',
          icon: Ionicons.person_outline,
        ),
        SettingsOption(
          key: 'changePassword',
          label: 'Change Password',
          helpText: 'Update your password',
          icon: Ionicons.lock_closed_outline,
        ),
        SettingsOption(
          key: 'language',
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
          key: 'emailNotifications',
          label: 'Email Notifications',
          helpText: 'Receive notifications via email',
          icon: Ionicons.mail_outline,
        ),
        SettingsOption(
          key: 'pushNotifications',
          label: 'Push Notifications',
          helpText: 'Receive push notifications',
          icon: Ionicons.notifications_outline,
        ),
        SettingsOption(
          key: 'smsNotifications',
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
          key: 'blockedAccounts',
          label: 'Blocked Accounts',
          helpText: 'Manage blocked accounts',
          icon: Ionicons.person_remove_outline,
        ),
        SettingsOption(
          key: 'privacyPolicy',
          label: 'Privacy Policy',
          helpText: 'View our privacy policy',
          icon: Ionicons.document_text_outline,
        ),
        SettingsOption(
          key: 'termsOfService',
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
          key: 'aboutUs',
          label: 'About Us',
          helpText: 'Learn more about us',
          icon: Ionicons.information_circle_outline,
        ),
        SettingsOption(
          key: 'appVersion',
          label: 'App Version',
          helpText: 'Check the app version',
          icon: Ionicons.phone_portrait_outline,
        ),
        SettingsOption(
          key: 'contactUs',
          label: 'Contact Us',
          helpText: 'Get in touch with us',
          icon: Ionicons.mail_open_outline,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
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
                'Settings',
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
            itemCount: settingsSections.length,
            itemBuilder: (context, index) {
              final section = settingsSections[index];
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color.fromARGB(255, 252, 171, 134),
                    ),
                  ),
                ),
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
                        if (option.key == 'changePassword') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PasswordResetScreen(),
                            ),
                          );
                        } else {
                          // Handle other options if needed
                        }
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
                icon: Icon(
                  Ionicons.logo_facebook,
                  color: Color.fromARGB(255, 243, 134, 84),
                ),
                onPressed: () {
                  print('Facebook');
                },
              ),
              IconButton(
                icon: Icon(
                  Ionicons.logo_twitter,
                  color: Color.fromARGB(255, 243, 134, 84),
                ),
                onPressed: () {
                  print('Twitter');
                },
              ),
              IconButton(
                icon: Icon(
                  Ionicons.logo_instagram,
                  color: Color.fromARGB(255, 243, 134, 84),
                ),
                onPressed: () {
                  print('Instagram');
                },
              ),
              IconButton(
                icon: Icon(
                  Ionicons.log_out_outline,
                  color: Color.fromARGB(255, 243, 134, 84),
                ),
                onPressed: () {
                  print('Logout');
                  _auth.signout();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => LoginOrSignup()),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}

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
  final String key; // Unique key for each option
  final String label;
  final String helpText;
  final IconData icon;

  SettingsOption({
    required this.key,
    required this.label,
    required this.helpText,
    required this.icon,
  });
}
