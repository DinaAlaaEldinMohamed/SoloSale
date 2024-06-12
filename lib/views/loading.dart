import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text(
          'Loading ..........',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
