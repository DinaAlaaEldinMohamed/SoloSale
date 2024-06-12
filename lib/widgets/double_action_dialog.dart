import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/widgets/buttons/secondary_button.dart';
import 'package:flutter_pos/widgets/custom_elevated_button.dart';

class DoubleActionDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirm;
  final String cancel;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  const DoubleActionDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.confirm,
    required this.cancel,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                backgroundColor: gray200Color,
                textColor: textDarkColor,
                onPressed: onCancel,
                label: cancel,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: CustomElevatedButton(
                backgroundColor: Colors.red,
                onPressed: onConfirm,
                label: confirm,
              ),
            ),
          ],
        )
      ],
    );
  }
}
