import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'home_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      splash: 'assets/images/logo.png',
      nextScreen: const HomeScreen(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.deepPurpleAccent,
    );
  }
}
