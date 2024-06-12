import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/const.dart';

class DashedLine extends StatelessWidget {
  final double height;
  final Color color;
  final double width;
  const DashedLine(
      {this.height = 1, this.color = textGrayColor, this.width = 2, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          final dashWidth = width;
          final dashHeight = height;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();

          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
