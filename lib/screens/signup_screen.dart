import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newchat/controller/login_controller.dart';
import 'package:newchat/screens/login_screen.dart';

import '../components/sign_login.dart';
import '../utils/mythems.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final LoginController _loginController = Get.put(LoginController());
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
                      Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 35, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
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
                                decoration: InputDecoration(
                                  hintText: "Full Name",
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
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
                                  hintText: "Enter your email",
                                  prefixIcon: Icon(Icons.email),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Obx(
                                () => TextFormField(
                                  controller: _passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }

                                    return null;
                                  },
                                  obscureText:
                                      _loginController.isPasswordHidden.value,
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
                              height: 2,
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(20.0),
                            //   child: Obx(
                            //     () => TextFormField(
                            //       obscureText:
                            //           _loginController.isPasswordHidden.value,
                            //       decoration: InputDecoration(
                            //         hintText: "Repeat password",
                            //         prefix: Icon(
                            //           Icons.lock,
                            //           color: MyThem.button,
                            //         ),
                            //         suffixIcon: GestureDetector(
                            //           onTap: () {
                            //             _loginController.isPasswordHidden(
                            //                 !_loginController
                            //                     .isPasswordHidden.value);
                            //           },
                            //           child: Icon(_loginController
                            //                   .isPasswordHidden.value
                            //               ? Icons.visibility
                            //               : Icons.visibility_off),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
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
                                await _loginController.signUpWithPassword(
                                    email: email, password: password);
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Already have an account?'),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (c) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Login In',
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
