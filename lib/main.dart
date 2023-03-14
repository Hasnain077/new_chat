import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newchat/screens/login_screen.dart';
import 'package:newchat/screens/signup_screen.dart';
import 'package:newchat/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
