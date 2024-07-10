import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_pass/authentication/login.dart';
import 'package:app_pass/services/auth.dart';

class SignUpPage extends StatefulWidget {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
        backgroundColor: Color.fromRGBO(246, 208, 183, 1),
      ),
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
                    'Create your account!',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 243, 134, 84),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildTextField(_nameController, 'Name'),
                  SizedBox(height: 8),
                  _buildTextField(_usernameController, 'Username'),
                  SizedBox(height: 8),
                  _buildTextField(
                      _emailController, 'Email', TextInputType.emailAddress),
                  SizedBox(height: 8),
                  _buildTextField(_passwordController, 'Password',
                      TextInputType.visiblePassword),
                  SizedBox(height: 8),
                  _buildTextField(
                    _confirmPasswordController,
                    'Confirm Password',
                    TextInputType.visiblePassword,
                  ),
                  SizedBox(height: 8),
                  _buildTextField(_recoveryEmailController, 'Recovery Email',
                      TextInputType.emailAddress),
                  SizedBox(height: 8),
                  _buildTextField(
                      _phoneController, 'Phone Number', TextInputType.phone),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Sign up logic here
                        dynamic result = await _auth
                            .registerwithemailandpassword(email, password);
                        if (result != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Account created successfully')));
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => Login()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Error creating account')));
                        }
                      }
                    },
                    child: Text('Create Account'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(246, 208, 183, 1),
                      side:
                          BorderSide(color: Color.fromARGB(255, 243, 134, 84)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
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
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
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
