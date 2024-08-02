import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:app_pass/authentication/login_or_signup.dart';
import 'package:app_pass/services/auth.dart';
import 'package:app_pass/authentication/password_reset_screen.dart';
import 'package:app_pass/authentication/profile.dart';
import 'package:app_pass/pages/share/share.dart';
import 'package:url_launcher/url_launcher.dart';

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
          helpText: 'Version :1.0.1',
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
  final Uri _url = Uri.parse(
      'https://mulindwamarkmyles.github.io/aboutusmulindwa.github.io/about-us.html');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  void _contactUs() async {
    final Email email = Email(
      body: '',
      subject: '',
      recipients: ['apppass@company.com'],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print('Failed to send email: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final Color scaffoldBackgroundColor = Color.fromARGB(255, 243, 220, 205);
    final Color iconColor = Color.fromARGB(255, 243, 134, 84);

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
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
                            builder: (_) => SharePage(),
                          ),
                        );
                        break;
                      case 'privacyPolicy':
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AboutDetailScreen(
                              title: 'Privacy Policy',
                              content: '''
Welcome to App Pass Your privacy is important to us. This Privacy Policy outlines how we collect, use, and protect your information when you use our app.

1. Information We Collect.

We collect the following types of information:
                                
    - Personal Information: This includes your email address, name, and other details provided during registration.
    - Usage Data: Information about how you use the app, including interactions with the app and features you access.
    - Device Information: Information about the device you use to access the app, such as device type, operating system, and unique device identifiers.

2. How We Use Your Information
We use your information to:    

    - Provide, operate, and maintain our app.
    - Improve, personalize, and expand our app.
    - Communicate with you, including sending updates and notifications.
    - Ensure the security and integrity of our app.

3. Sharing Your Information
We do not share your personal information with third parties, except

    - When required by law or to comply with legal processes.
    - To protect and defend our rights and property.
    - With your consent or at your direction.

4. Data Security
We implement a variety of security measures to ensure the safety of your personal information. These measures include encryption, secure access controls, and regular security audits.

5. Your Rights
You have the right to access, correct, or delete your personal information. You can also opt-out of receiving marketing communications from us at any time.

6. Changes to This Privacy Policy
We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.

7. Contact Us
If you have any questions about this Privacy Policy, please contact us at [Contact Information].
                              ''',
                            ),
                          ),
                        );
                        break;
                      case 'termsOfService':
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AboutDetailScreen(
                              title: 'Terms of Service',
                              content: '''
Welcome to App Pass By using our app, you agree to comply with and be bound by the following terms and conditions.

1. Acceptance of Terms

By accessing or using App Pass, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the app.

2. Use of the App

You agree to use the app only for lawful purposes and in a way that does not infringe the rights of others or restrict or inhibit their use and enjoyment of the app.

3. User Accounts

To use certain features of the app, you must create an account. You agree to provide accurate and complete information and to update your information as necessary. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.

4. Password Management

You are responsible for managing your passwords securely. [App Name] provides tools to help you store and organize your passwords, but you must ensure that your use of these tools complies with best security practices.

5. Intellectual Property

All content and materials available on the app, including but not limited to text, graphics, logos, and software, are the property of [App Name] or its licensors and are protected by intellectual property laws.

6. Termination

We reserve the right to terminate or suspend your account and access to the app at our sole discretion, without notice and without liability, for conduct that we believe violates these Terms of Service or is harmful to other users, us, or third parties.

7. Limitation of Liability

To the maximum extent permitted by law, [App Name] shall not be liable for any indirect, incidental, special, or consequential damages arising out of or in connection with your use of the app.

8. Changes to Terms of Service

We may modify these Terms of Service at any time. We will notify you of any changes by posting the new Terms of Service on this page. Your continued use of the app after any such changes constitutes your acceptance of the new terms.

9. Governing Law

These Terms of Service shall be governed by and construed in accordance with the laws of [Your Jurisdiction], without regard to its conflict of law principles.

10. Contact Us

If you have any questions about these Terms of Service, please contact us at [Contact Information].
                              ''',
                            ),
                          ),
                        );
                        break;
                      case 'aboutUs':
                        _launchUrl();
                        break;
                      case 'appVersion':
                        break;
                      case 'contactUs':
                        _contactUs();
                        break;
                      default:
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
                Ionicons.logo_twitter,
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
              onPressed: () async {
                bool? confirmLogout = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Adjust this value for more boxy or rounded corners
                      ),
                      title: Text('Confirm Logout',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                      content: Text('Are you sure you want to log out?',
                          style: GoogleFonts.poppins()),
                      backgroundColor: Color.fromRGBO(244, 220, 205, 1),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel',
                              style: GoogleFonts.poppins(
                                color: Color.fromARGB(255, 243, 134, 84),
                                fontSize: 16,
                              )),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        TextButton(
                          child: Text('Logout',
                              style: GoogleFonts.poppins(
                                color: Color.fromARGB(255, 243, 134, 84),
                                fontSize: 16,
                              )),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    );
                  },
                );

                if (confirmLogout == true) {
                  auth.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => LoginOrSignup()),
                  );
                }
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

  const AboutDetailScreen(
      {Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          // Center align the title
          child: Text(
            title,
            selectionColor: Color.fromRGBO(244, 220, 205, 1),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            content,
            textAlign: TextAlign.left, // Align the text to the left
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 14.0, // Increase font size for better readability
                height: 1.5, // Add line height for spacing between lines
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
