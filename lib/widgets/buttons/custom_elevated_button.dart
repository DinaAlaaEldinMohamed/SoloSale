import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/const.dart';

class CustomElevatedButton extends StatelessWidget {
  final Color backgroundColor;
  final String label;
  final Color textColor;
  final void Function()? onPressed;
  const CustomElevatedButton(
      {required this.label,
      required this.onPressed,
      this.backgroundColor = primaryColor,
      this.textColor = Colors.white,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            fixedSize: const Size(double.maxFinite, 60),
            backgroundColor: backgroundColor,
            foregroundColor: textColor),
        onPressed: onPressed,
        child: Text(label));
  }
}
