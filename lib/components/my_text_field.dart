import 'package:flutter/material.dart';
import 'package:newchat/utils/mythems.dart';

class MyTextField extends StatelessWidget {
  final String? hintText;
  final BorderRadius? borderRadius;
  final Color? fillColor;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final bool isObscure;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  const MyTextField(
      {super.key,
      this.isObscure = false,
      this.hintText,
      this.borderRadius,
      this.fillColor,
      this.controller,
      this.validator,
      this.inputType,
      this.suffixWidget,
      this.prefixWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        obscureText: isObscure,
        controller: controller,
        textInputAction: TextInputAction.next,
        keyboardType: inputType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          suffix: suffixWidget,
          prefix: prefixWidget,
        ),
      ),
    );
  }
}
