// lib/presentation/pages/onboarding_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'auth_gate.dart'; // Kita akan buat file ini

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthGate()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.creamBeige,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ganti dengan logo jika ada
            Icon(Icons.storefront, size: 100, color: AppTheme.tomatoRed),
            SizedBox(height: 24),
            Text(
              'KantinKU',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppTheme.tomatoRed,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Jelajahi Kantin UB Dengan Mudah',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.warmBrown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}