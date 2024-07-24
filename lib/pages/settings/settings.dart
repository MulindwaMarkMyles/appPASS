import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:app_pass/authentication/login_or_signup.dart';
import 'package:app_pass/services/auth.dart';
import 'package:app_pass/authentication/password_reset_screen.dart';
import 'package:app_pass/authentication/profile.dart';
import 'package:app_pass/pages/share/share.dart'; // Import the share password screen

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
          key: 'sharePassword',
          label: 'Share Password',
          helpText: 'Share your password via email or QR code',
          icon: Ionicons.share_social_outline,
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
    final Color scaffoldBackgroundColor = Color.fromARGB(255, 243, 220, 205);
    final Color iconColor = Color.fromARGB(255, 243, 134, 84);

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/Image1.png',
              width: 40,
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              'Settings',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: iconColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(244, 203, 176, 1),
      ),
      body: ListView.builder(
        itemCount: settingsSections.length,
        itemBuilder: (context, index) {
          final section = settingsSections[index];
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromRGBO(244, 203, 176, 1),
                ),
              ),
            ),
            child: ExpansionTile(
              collapsedIconColor: iconColor,
              iconColor: iconColor,
              leading: Icon(section.icon, color: iconColor),
              title: Text(section.title),
              children: section.settingsOptions.map((option) {
                return ListTile(
                  leading: Icon(option.icon, color: iconColor),
                  title: Text(option.label),
                  subtitle: Text(option.helpText),
                  onTap: () {
                    switch (option.key) {
                      case 'changePassword':
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PasswordResetScreen(),
                          ),
                        );
                        break;
                      case 'profile':
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProfileScreen(),
                          ),
                        );
                        break;
                      case 'sharePassword':
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SharePage(password: 'YourPasswordHere'), // Replace with actual password
                          ),
                        );
                        break;
                      case 'aboutUs':
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AboutDetailScreen(
                              title: 'About Us',
                              content: 'Welcome to our app We are G-09, a dedicated group of Computer Science students from Makerere University. Our team is passionate about leveraging technology to create innovative solutions.As part of our journey, we have developed several impactful projects, including Shoppie, a cutting-edge e-commerce platform designed to enhance your shopping experience. Our goal is to bring you technology that simplifies and enriches your life Thank you for choosing our app. We hope you enjoy using it as much as we enjoyed creating it! ',
                            ),
                          ),
                        );
                        break;
                      case 'appVersion':
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AboutDetailScreen(
                              title: 'App Version',
                              content: 'Version :1.0.1',
                            ),
                          ),
                        );
                        break;
                      case 'contactUs':
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AboutDetailScreen(
                              title: 'Contact Us',
                              content: 'Contact G-09 Developer through mail:g09@mac.ac.ug as well as all media platforms at G-09',
                            ),
                          ),
                        );
                        break;
                      default:
                        // Handle other options if needed
                        break;
                    }
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: scaffoldBackgroundColor, // Set the color here
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Ionicons.logo_facebook,
                color: iconColor,
              ),
              onPressed: () {
                print('Facebook');
              },
            ),
            IconButton(
              icon: Icon(
                Ionicons.logo_xing,
                color: iconColor,
              ),
              onPressed: () {
                print('Twitter');
              },
            ),
            IconButton(
              icon: Icon(
                Ionicons.logo_instagram,
                color: iconColor,
              ),
              onPressed: () {
                print('Instagram');
              },
            ),
            IconButton(
              icon: Icon(
                Ionicons.log_out_outline,
                color: iconColor,
              ),
              onPressed: () {
                print('Logout');
                _auth.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => LoginOrSignup()),
                );
              },
            ),
          ],
        ),
      ),
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
  final String key;
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

class AboutDetailScreen extends StatelessWidget {
  final String title;
  final String content;

  AboutDetailScreen({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(content),
      ),
    );
  }
}
