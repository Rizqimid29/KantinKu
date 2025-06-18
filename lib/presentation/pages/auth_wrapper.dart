// lib/presentation/pages/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _showLoginPage = true;

  void toggleView() {
    setState(() {
      _showLoginPage = !_showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showLoginPage) {
      return LoginPage(onSwitchToRegister: toggleView);
    } else {
      return SignUpPage(onSwitchToLogin: toggleView);
    }
  }
}