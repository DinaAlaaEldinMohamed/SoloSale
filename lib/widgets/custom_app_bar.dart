import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final void Function()? onPressed;

  const CustomAppBar({this.title = '', this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(title),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
