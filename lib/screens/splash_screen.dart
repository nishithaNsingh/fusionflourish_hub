import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late bool _isDisposed; // Use late to initialize in initState
  late Timer _timer; // Declare the timer variable

  @override
  void initState() {
    super.initState();
    _isDisposed = false; // Initialize _isDisposed
    _startTimer();
    _timer = Timer(const Duration(seconds: 5), _startTimer);// Start the timer
  }

  @override
  void dispose() {
    _isDisposed = true; // Set _isDisposed to true when the widget is disposed
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> _startTimer() async {
    await Future.delayed( Duration(seconds: 5));

    if (!_isDisposed) {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null && session.user != null) {
        // Navigator.pushReplacementNamed(context, '/home_screen');
        Navigator.of(context).pushReplacementNamed('/home_screen');

      } else {
        Navigator.pushReplacementNamed(context, '/login_screen');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: content(),
    );
  }

  Widget content() {
    return Center(
      child: Container(
        child: Lottie.asset(
          'assets/newlogovid.json',
        ),
      ),
    );
  }
}
