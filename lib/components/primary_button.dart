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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onButtonPressed,
          style: buttonStyle ??
              ElevatedButton.styleFrom(
                backgroundColor: MyThem.button,
                minimumSize: Size(170, 60),
              ),
          child: Center(
            child: Expanded(
              child: Text(
                textOnButton ?? "",
                style: textStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}