// lib/src/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        _checkLoginStatus();
      }
    });
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (mounted) {
      if (token != null) {
        // Token exists, navigate to home screen
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // No token, navigate to login screen
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/images/splash_logo.png',
                width: 200.0,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Image.asset(
                'lib/assets/images/text_logo.png',
                width: 200.0,
              ),
            ],
          ), // Ensure the image is added in pubspec.yaml
        ),
      ),
    );
  }
}
