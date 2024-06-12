import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/const.dart';

class InfoHeader extends StatelessWidget {
  final String title, trailing;
  final VoidCallback onTap;
  const InfoHeader(
      {required this.title,
      required this.trailing,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color(0xFF206DE1),
        ),
        child: ListTile(
          title: Text(
            title,
            style: bodyText(whiteColor),
          ),
          trailing: Opacity(
            opacity: 0.7,
            child: Text(trailing, style: bodyText(whiteColor)),
          ),
        ),
      ),
    );
  }
}
