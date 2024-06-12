import 'package:flutter/material.dart';

Widget imageDialog() {
  return AlertDialog(
      title: const Text('Select image'),
      content: SizedBox(
          height: 170,
          child: Column(children: [
            ListTile(
              leading: const Icon(Icons.collections_outlined),
              title: const Text('Gallery'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Camera'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.delete_outlined),
              title: const Text('Delete'),
              onTap: () {},
            ),
          ])));
}
