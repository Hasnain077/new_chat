import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:newchat/controller/login_controller.dart';
import 'package:newchat/utils/mythems.dart';

import '../components/my_text_field.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final LoginController _loginController = Get.put(LoginController());
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  RxBool isPassword = true.obs;
  RxBool isNewPassword = true.obs;
  RxBool isLoading = false.obs;

  @override
  void dispose() {
    _confirmPassword.dispose();
    _oldPassword.dispose();
    _newPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyThem.primary,
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => MyTextField(
                    controller: _oldPassword,
                    validator: (st) {
                      if (st == null || st.isEmpty) {
                        return "This field is required";
                      }

                      if (st.length < 8) {
                        return "Password length should be minimum 8 characters";
                      }

                      return null;
                    },
                    isObscure: isPassword.value,
                    hintText: "Old password",
                    prefixWidget: const Icon(
                      Icons.lock,
                      color: MyThem.primary,
                    ),
                    suffixWidget: GestureDetector(
                      onTap: () {
                        isPassword(!isPassword.value);
                      },
                      child: Icon(isPassword.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                ),
                Obx(
                  () => MyTextField(
                    controller: _newPassword,
                    validator: (st) {
                      if (st == null || st.isEmpty) {
                        return "This field is required";
                      }
                      if (_oldPassword.text == st) {
                        return "New password cannot be same as old password";
                      }

                      return null;
                    },
                    isObscure: isNewPassword.value,
                    hintText: "Enter your new password",
                    prefixWidget: Icon(
                      Icons.lock,
                      color: MyThem.primary,
                    ),
                    suffixWidget: GestureDetector(
                      onTap: () {
                        isNewPassword(!isNewPassword.value);
                      },
                      child: Icon(isNewPassword.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                ),
                Obx(
                  () => MyTextField(
                    controller: _confirmPassword,
                    validator: (st) {
                      if (st == null || st.isEmpty) {
                        return "This field is required";
                      }

                      if (_newPassword.text != st) {
                        return "Confirm Password do not match";
                      }

                      return null;
                    },
                    isObscure: isNewPassword.value,
                    hintText: "Re-Enter your password",
                    prefixWidget: const Icon(
                      Icons.lock,
                      color: MyThem.primary,
                    ),
                    suffixWidget: GestureDetector(
                      onTap: () {
                        isNewPassword(!isNewPassword.value);
                      },
                      child: Icon(isNewPassword.value
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
                    visible: isLoading.value,
                    replacement: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyThem.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        String oldPassword = _oldPassword.text;
                        String newPassword = _newPassword.text;
                        isLoading(true);
                        String? result = await _loginController.changePassword(
                            context, oldPassword, newPassword);
                        isLoading(false);
                        if (result != null) {
                          Get.snackbar("error", result);
                        } else {
                          Get.snackbar('Password Changed',
                              "Your Password changed successfully");
                        }
                        _newPassword.text = "";
                        _oldPassword.text = "";
                        _confirmPassword.text = "";

                        Navigator.pop(context);
                      },
                      child: Center(
                        child: const Text(
                          'Change Password',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
