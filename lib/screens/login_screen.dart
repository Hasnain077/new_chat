import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:newchat/components/my_text_field.dart';

import 'package:newchat/components/primary_button.dart';

import 'package:newchat/controller/login_controller.dart';
import 'package:newchat/screens/home_screen.dart';

import 'package:newchat/screens/signup_screen.dart';
import 'package:newchat/utils/mythems.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _loginController = Get.put(LoginController());

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _resetController = TextEditingController();
  Future resetPassword() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: _resetController.text.trim());
    Navigator.pop(context);

    Get.snackbar("Request Sent", "Password reset request sent to ",
        snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _authController.isLoginPasswordHidden.value;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: MyThem.primary,
      ),
      body: SafeArea(
        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [MyThem.primary, MyThem.primary],
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
                        "Let's chat_App",
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
                            MyTextField(
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
                              hintText: "Enter your email or ID",
                              prefixWidget: Icon(Icons.person),
                            ),
                            Obx(
                              () => MyTextField(
                                hintText: "Enter your password",
                                controller: _passwordController,
                                isObscure: _loginController
                                    .isLoginPasswordHidden.value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This field is required';
                                  }

                                  return null;
                                },
                                prefixWidget: Icon(
                                  Icons.lock,
                                  color: MyThem.primary,
                                ),
                                suffixWidget: GestureDetector(
                                  onTap: () {
                                    _loginController.isLoginPasswordHidden(
                                        !_loginController
                                            .isLoginPasswordHidden.value);
                                  },
                                  child: Icon(_loginController
                                          .isLoginPasswordHidden.value
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        title:
                                            const Text("Reset your password"),
                                        content: SizedBox(
                                          child: Column(
                                            children: [
                                              const Text(
                                                  "Receive an email to reset your password"),
                                              TextFormField(
                                                controller: _resetController,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "This field required";
                                                  }
                                                  if (!value.isEmail) {
                                                    return "Invalid email";
                                                  }

                                                  return null;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 8),
                                        actions: [
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('No'),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              TextButton(
                                                onPressed: resetPassword,
                                                child: const Text("Yes"),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: MyThem.primary,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Obx(
                              () => Visibility(
                                visible: _loginController.isLoginLoading.value,
                                replacement: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MyThem.primary,
                                    minimumSize: const Size(170, 60),
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
                                    String? message = await _loginController
                                        .signInWithEmailPassword(
                                            email: email, password: password);
                                    if (message == null) {
                                      if (context.mounted) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const HomeScreen()),
                                            (route) => false);
                                      }
                                    } else {
                                      Get.snackbar("failed", message,
                                          snackPosition: SnackPosition.BOTTOM);
                                    }
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              ),
                            ),
                            const SizedBox(
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
                                      color: MyThem.primary,
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
