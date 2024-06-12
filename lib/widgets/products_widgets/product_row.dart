import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/const.dart';

// ignore: must_be_immutable
class CustomRow extends StatelessWidget {
  String label;
  String value;
  TextStyle? style;
  bool divide;

  CustomRow(
      {this.label = '',
      this.value = '',
      super.key,
      this.style,
      this.divide = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: bodyText(lightGrayColor),
            ),
            const SizedBox(width: 10),
            Flexible(
              flex: 1,
              child: Text(
                value,
                style: style,
              ),
            ),
          ],
        ),
        divide ? const Divider() : const SizedBox(),
      ],
    );
  }
}
