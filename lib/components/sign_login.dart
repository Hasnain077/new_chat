import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newchat/components/primary_button.dart';

import '../screens/signup_screen.dart';
import '../utils/mythems.dart';

class SignLoginScreen extends StatelessWidget {
  final String? text;
  final Function()? onTap;
  final Function()? onPressed;
  final Color? color;
  final TextStyle? textStyle;
  const SignLoginScreen(
      {Key? key,
      this.text,
      this.onTap,
      this.onPressed,
      this.color,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPasswordHidden = true;
    bool isCkecked = true;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: SafeArea(
          child: SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [MyThem.primary, MyThem.button],
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/png/parcel.png",
                      height: 130,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      text ?? "Login",
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      text ?? "Welcome to chat app",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(80.0),
                          topRight: Radius.circular(80.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 80,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "Enter your email",
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              obscureText: isPasswordHidden,
                              decoration: InputDecoration(
                                hintText: "Enter your password",
                                prefix: Icon(
                                  Icons.lock,
                                  color: MyThem.button,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    isPasswordHidden = !isPasswordHidden;
                                  },
                                  child: Icon(isPasswordHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyThem.button,
                              minimumSize: Size(170, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('New User?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => const SignUpScreen()),
                                  );
                                },
                                child: const Text(
                                  'Create an account',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
