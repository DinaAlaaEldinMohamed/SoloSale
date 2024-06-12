import 'package:flutter/material.dart';

class GridViewItem extends StatelessWidget {
  final String label;
  final Color color;
  final Widget child;
  final String route;

  const GridViewItem(
      {required this.label,
      required this.color,
      required this.child,
      required this.route,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                  radius: 40,
                  backgroundColor: color.withOpacity(.3),
                  child: child),
              const SizedBox(
                height: 10,
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
