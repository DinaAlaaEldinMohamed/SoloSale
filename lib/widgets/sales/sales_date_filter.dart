import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/const.dart';

// ignore: must_be_immutable
class SalesDateFilter extends StatefulWidget {
  void Function()? onTap;
  SalesDateFilter({this.onTap, super.key});

  @override
  State<SalesDateFilter> createState() => _SalesDateFilterState();
}

class _SalesDateFilterState extends State<SalesDateFilter> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Any Date',
              style: bodyText(
                mediumGrayColor,
              ),
            ),
            const Icon(
              Icons.expand_more,
              color: iconGrayColor,
            ),
          ],
        ),
      ),
    );
  }
}
