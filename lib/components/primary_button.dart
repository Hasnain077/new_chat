import 'package:flutter/material.dart';

import '../utils/mythems.dart';

class PrimaryButton extends StatelessWidget {
  final String? textOnButton;

  final Function()? onButtonPressed;
  final ButtonStyle? buttonStyle;
  final TextStyle? textStyle;

  const PrimaryButton({
    Key? key,
    this.buttonStyle,
    this.onButtonPressed,
    this.textOnButton,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ElevatedButton(
        onPressed: onButtonPressed,
        style: buttonStyle ??
            ElevatedButton.styleFrom(
              backgroundColor: MyThem.primary,
              minimumSize: Size(170, 60),
            ),
        child: Center(
          child: Text(
            textOnButton ?? "",
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
