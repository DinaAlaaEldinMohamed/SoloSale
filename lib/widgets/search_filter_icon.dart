import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/const.dart';

class SearchFilterIcon extends StatelessWidget {
  const SearchFilterIcon({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryButtonColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: primaryColor),
      ),
    );
  }
}
