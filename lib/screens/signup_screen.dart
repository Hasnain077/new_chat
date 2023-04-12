import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newchat/components/my_text_field.dart';
import 'package:newchat/controller/login_controller.dart';
import 'package:newchat/screens/login_screen.dart';

import '../utils/mythems.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final LoginController _authController = LoginController.instance;
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    _authController.isPasswordHidden(true);
    if (_authController.currentUser.value != null) {
      _phoneController.text =
          _authController.currentUser.value?.phoneNumber ?? "";
      _nameController.text =
          _authController.currentUser.value?.displayName ?? "";
      _emailController.text = _authController.currentUser.value?.email ?? "";
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _confPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: MyThem.primary,
      ),
      body: SafeArea(
        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
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
                      "Sign Up",
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
                          const SizedBox(
                            height: 40,
                          ),
                          MyTextField(
                            controller: _nameController,
                            validator: (st) {
                              if (st == null || st.isEmpty) {
                                return "This field is required";
                              }
                              return null;
                            },
                            hintText: "Enter Your full Name",
                            prefixWidget: Icon(Icons.person),
                          ),
                          MyTextField(
                            controller: _phoneController,
                            validator: (st) {
                              if (st == null || st.isEmpty) {
                                return "This field is required";
                              }

                              return null;
                            },
                            hintText: "Enter Mobile Numbre",
                            inputType: TextInputType.number,
                            prefixWidget: Icon(Icons.phone_android),
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
                            hintText: "Enter your email",
                            prefixWidget: Icon(Icons.email),
                          ),
                          Obx(
                            () => MyTextField(
                              controller: _passwordController,
                              validator: (st) {
                                if (st == null || st.isEmpty) {
                                  return "This field is required";
                                }
                                if (st.length < 8) {
                                  return "Password length should be minimum 8 characters";
                                }

                                return null;
                              },
                              isObscure: _authController.isPasswordHidden.value,
                              hintText: "Enter your password",
                              prefixWidget: Icon(
                                Icons.lock,
                                color: MyThem.primary,
                              ),
                              suffixWidget: GestureDetector(
                                onTap: () {
                                  _authController.isPasswordHidden(
                                      !_authController.isPasswordHidden.value);
                                },
                                child: Icon(
                                    _authController.isPasswordHidden.value
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                              ),
                            ),
                          ),
                          Obx(
                            () => MyTextField(
                              controller: _confPasswordController,
                              validator: (st) {
                                if (st == null || st.isEmpty) {
                                  return "This field is required";
                                }

                                if (_passwordController.text != st) {
                                  return "Confirm Password do not match";
                                }

                                return null;
                              },
                              isObscure: _authController.isPasswordHidden.value,
                              hintText: "Re-Enter your password",
                              prefixWidget: const Icon(
                                Icons.lock,
                                color: MyThem.primary,
                              ),
                              suffixWidget: GestureDetector(
                                onTap: () {
                                  _authController.isPasswordHidden(
                                      !_authController.isPasswordHidden.value);
                                },
                                child: Icon(
                                    _authController.isPasswordHidden.value
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Obx(
                            () => Visibility(
                              visible: _authController.isSignUpLoading.value,
                              replacement: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyThem.primary,
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
                                  String name = _nameController.text;
                                  String mobile = _phoneController.text;
                                  bool result =
                                      await _authController.signUpWithPassword(
                                    email: email,
                                    password: password,
                                    mobile: mobile,
                                    name: name,
                                  );
                                  if (result) {
                                    Get.snackbar("User Registered", "",
                                        snackPosition: SnackPosition.BOTTOM);
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    } else {
                                      Get.snackbar("User not Registered", "",
                                          snackPosition: SnackPosition.BOTTOM);
                                    }
                                  }
                                  _emailController.text = "";
                                  _nameController.text = "";
                                  _passwordController.text = "";
                                  _confPasswordController.text = "";
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
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
    );
  }
}
