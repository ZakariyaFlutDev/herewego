import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herewego/pages/signIn_page.dart';
import 'package:herewego/services/auth_service.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/utols_service.dart';

import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static const String id = "sign_up_page";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignUp() {
    String name = nameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if (name.isEmpty || email.isEmpty || password.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    AuthService.signUp(email: email, password: password).then((user) => {
          _getUser(user),
        });

    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  _getUser(User? user) async {
    setState(() {
      _isLoading = false;
    });

    if (user != null) {
      await Prefs.saveUserId(user.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      Utils().showToast("Check your INFOs");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Name",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Password",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: _doSignUp,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Already have an account?"),
                    SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, SignInPage.id);
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
