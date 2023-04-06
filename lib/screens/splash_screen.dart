import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newchat/components/primary_button.dart';
import 'package:newchat/screens/home_screen.dart';
import 'package:newchat/screens/login_screen.dart';
import 'package:newchat/screens/signup_screen.dart';
import 'package:newchat/utils/mythems.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animDouble;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _animDouble =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _animationController.forward();
    Timer(const Duration(seconds: 3), () {
      bool isLogin = _auth.currentUser != null;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => isLogin ? const HomeScreen() : const LoginScreen(),
        ),
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [MyThem.primary, Colors.white],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animDouble,
              child: Image.asset(
                "assets/png/chatlogo.png",
                height: 250,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Hello!',
              style: TextStyle(
                fontSize: 80,
              ),
            ),
            const Text(
              'Lets get started',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            PrimaryButton(
              onButtonPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (c) => const SignUpScreen(),
                  ),
                );
              },
              textOnButton: "SIGN UP",
              textStyle: TextStyle(
                color: Colors.white,
              ),
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: MyThem.primary,
                minimumSize: Size(170, 60),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            PrimaryButton(
              onButtonPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (c) => const LoginScreen(),
                  ),
                );
              },
              textOnButton: "SIGN IN",
              textStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: Size(170, 60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
