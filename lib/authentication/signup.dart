import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_pass/authentication/login.dart';
import 'package:app_pass/services/auth.dart';
import 'package:ionicons/ionicons.dart';
import 'package:auth_button_kit/auth_button_kit.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _recoveryEmailController = TextEditingController();
  final _phoneController = TextEditingController();
  final AuthService _auth = AuthService();
  String email = "";
  String password = "";
  String name = "";
  String username = "";
  String recoveryEmail = "";
  int phoneNumber = 0;

  Method? brandSelected;

  void toogle(Method brand) async {
    setState(() => brandSelected = Method.custom);
    if (_formKey.currentState!.validate()) {
      dynamic result = await _auth.registerWithEmailAndPassword(
          email, password, name, username, phoneNumber, recoveryEmail);
      if (result != null) {
        setState(() {
          brandSelected = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account created successfully')));
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => Login()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error creating account')));
      }
    } else {
      setState(() {
        brandSelected = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 243, 220, 205),
          leading: IconButton(
            icon: Icon(Ionicons.arrow_back_circle),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/Image1.png',
                    width: 80,
                    height: 80,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Gammli',
                      color: Color.fromRGBO(248, 105, 17, 1),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    _nameController,
                    'Name',
                    Icon(Ionicons.person_outline,
                        color: Color.fromRGBO(248, 105, 17, 1)),
                  ),
                  SizedBox(height: 8),
                  _buildTextField(
                    _usernameController,
                    'Username',
                    Icon(Ionicons.person_circle_outline,
                        color: Color.fromRGBO(248, 105, 17, 1)),
                  ),
                  SizedBox(height: 8),
                  _buildTextField(
                      _emailController,
                      'Email',
                      Icon(Ionicons.mail_outline,
                          color: Color.fromRGBO(248, 105, 17, 1)),
                      TextInputType.emailAddress),
                  SizedBox(height: 8),
                  _buildTextField(
                      _passwordController,
                      'Password',
                      Icon(Ionicons.lock_closed_outline,
                          color: Color.fromRGBO(248, 105, 17, 1)),
                      TextInputType.visiblePassword,
                      true),
                  SizedBox(height: 8),
                  _buildTextField(
                      _confirmPasswordController,
                      'Confirm Password',
                      Icon(Ionicons.lock_closed_outline,
                          color: Color.fromRGBO(248, 105, 17, 1)),
                      TextInputType.visiblePassword,
                      true),
                  SizedBox(height: 8),
                  _buildTextField(
                      _recoveryEmailController,
                      'Recovery Email',
                      Icon(Ionicons.mail_open_outline,
                          color: Color.fromRGBO(248, 105, 17, 1)),
                      TextInputType.emailAddress),
                  SizedBox(height: 8),
                  _buildTextField(
                      _phoneController,
                      'Phone Number',
                      Icon(Ionicons.call_outline,
                          color: Color.fromRGBO(248, 105, 17, 1)),
                      TextInputType.phone),
                  SizedBox(height: 16),
                  AuthButton(
                    onPressed: (b) => toogle(b),
                    brand: Method.custom,
                    text: 'SIGN UP',
                    textCentering: Centering.independent,
                    textColor: Colors.white,
                    backgroundColor: Color.fromRGBO(248, 105, 17, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.transparent
                            : Color.fromRGBO(248, 105, 17, 1),
                        width: 1.5,
                      ),
                    ),
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    showLoader: Method.custom == brandSelected,
                    loaderColor: Colors.white,
                    splashEffect: true,
                    customImage: Image.asset('assets/Image1.png'),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, Icon prefixIcon,
      [TextInputType keyboardType = TextInputType.text,
      bool isPassword = false]) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      onChanged: (value) {
        if (labelText == 'Email') {
          email = value;
        } else if (labelText == 'Password') {
          password = value;
        } else if (labelText == 'Phone Number') {
          phoneNumber = int.parse(value);
        } else if (labelText == 'Name') {
          name = value;
        } else if (labelText == 'Recovery Email') {
          recoveryEmail = value;
        } else if (labelText == 'Username') {
          username = value;
        }
      },
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        labelStyle: TextStyle(
          color: Colors.black,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(248, 105, 17, 1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(248, 105, 17, 1)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText is required';
        }
        if (labelText == 'Confirm Password' &&
            value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
