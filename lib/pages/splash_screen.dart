import 'package:betting_tennis/pages/home_page.dart';
import 'package:betting_tennis/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:betting_tennis/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  bool showHomePage;

  SplashScreen({Key? key, required this.showHomePage}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool animate = false;

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffdcbd),
      body: SafeArea(
        child: _circularAnimation(),
      ),
    );
  }

  Widget _circularAnimation() {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 2000),
        curve: Curves.bounceIn,
        height: animate ? 400 : 300,
        width: animate ? 400 : 300,
        child: const Image(
          image: AssetImage("assets/images/betting-tennis-logo.png"),
        ),
      ),
    );
  }

  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() => animate = true);
    await Future.delayed(const Duration(milliseconds: 1600));
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => widget.showHomePage ? HomePage() : OnboardingPage(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
      ),
    );
  }
}
