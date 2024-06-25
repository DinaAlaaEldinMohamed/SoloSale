import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/const.dart';

class CustomTextButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonLabel;
  const CustomTextButton({this.buttonLabel = '', this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 36,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFE0E0E0),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          height: 36,
          width: double.infinity,
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              buttonLabel,
              style: bodyText(lightGreyColor),
            ),
          ),
        ));
  }
}
