import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herewego/pages/home_page.dart';
import 'package:herewego/pages/signUp_page.dart';
import 'package:herewego/services/auth_service.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/utols_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  static const String id = "sign-in_page";

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignIn() {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if (email.isEmpty || password.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    AuthService.signIn(email: email, password: password).then((user) => {
          _getUser(user),
        });
  }

  _getUser(User? user) async {
    setState(() {
      _isLoading = false;
    });

    if (user != null) {
      await Prefs.saveUserId(user.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      Utils().showToast("Check your email or password");
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
                    onTap: _doSignIn,
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          "Sign In",
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
                      Text("Don't have an account?"),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, SignUpPage.id);
                        },
                        child: Text(
                          "Sign Up",
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
          )),
    );
  }
}
