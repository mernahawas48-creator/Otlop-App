import 'dart:async';

import 'package:flutter/material.dart';
import 'package:otlopapp/core/storage/app_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1200), _openNextScreen);
  }

  void _openNextScreen() {
    if (!mounted) return;

    final nextRoute = AppPreferences.hasSeenOnboarding
        ? '/auth'
        : '/onboarding';

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/splash_image.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
