import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos/utils/const.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  const CustomTextField(
      {this.labelText,
      this.controller,
      this.validator,
      super.key,
      this.inputFormatters,
      this.keyboardType});

  InputBorder get textFieldBorder => OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: borderColor));

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          border: textFieldBorder,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          focusedBorder: textFieldBorder.copyWith(
            borderSide: const BorderSide(
              width: 2,
              color: primaryLightColor,
            ),
          ),
          enabledBorder: textFieldBorder,
          errorBorder: textFieldBorder.copyWith(
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          labelText: labelText,
          labelStyle: bodyText(textPlaceholderColor),
        )
        //  hintStyle: bodyText(textPlaceholderColor)),
        );
  }
}
