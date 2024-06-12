import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/const.dart';

class SecondaryButton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String label;
  final VoidCallback onPressed;
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = secondaryButtonColor,
    this.textColor = primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 44,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              fixedSize: const Size(double.maxFinite, 60),
              backgroundColor: backgroundColor,
              foregroundColor: textColor,
            ),
            onPressed: onPressed,
            child: Text(label)));
  }
}
