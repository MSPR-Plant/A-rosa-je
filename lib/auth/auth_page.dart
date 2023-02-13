import 'package:flutter/material.dart';
import 'package:login_app/pages/login.dart';
import 'package:login_app/pages/register.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  // initially show the login page
  bool showLoginPage = true;

  //method of toggle (chnging page)
  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return Login(showRegisterPage: toggleScreens);
    } else {
      return Register(showLoginPage: toggleScreens);
    }
  }
}