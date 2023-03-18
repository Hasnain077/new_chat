import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:newchat/components/primary_button.dart';
import 'package:newchat/controller/login_button_controller.dart';
import 'package:newchat/controller/login_controller.dart';

import 'package:newchat/screens/signup_screen.dart';
import 'package:newchat/utils/mythems.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _loginController = Get.put(LoginController());
  final LoginButtonController _loginButtonController =
      Get.put(LoginButtonController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/png/parcel.png",
                        height: 100,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        "Login",
                        style: TextStyle(fontSize: 35, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Welcome to chat app",
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
                              height: 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: TextFormField(
                                controller: _emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This field is required';
                                  }
                                  if (!value.isEmail) {
                                    return 'Invalid email';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Enter your email or ID",
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Obx(
                                () => TextFormField(
                                  obscureText:
                                      _loginController.isPasswordHidden.value,
                                  controller: _passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Enter your password",
                                    prefix: Icon(
                                      Icons.lock,
                                      color: MyThem.button,
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        _loginController.isPasswordHidden(
                                            !_loginController
                                                .isPasswordHidden.value);
                                      },
                                      child: Icon(_loginController
                                              .isPasswordHidden.value
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    ),
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
                            Obx(
                              () => ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyThem.button,
                                  minimumSize: Size(170, 60),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  String email = _emailController.text;
                                  String password = _passwordController.text;
                                  await _loginController
                                      .signInWithEmailPassword(
                                          email: email, password: password);
                                  // _loginButtonController.isUnderLogin(
                                  //     !_loginButtonController
                                  //         .isUnderLogin.value);
                                },
                                child: Text(
                                  _loginButtonController.isUnderLogin.value
                                      ? 'Login'
                                      : "Please Wait...",
                                  style: TextStyle(color: Colors.white),
                                ),
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
      ),
    );
  }
}
