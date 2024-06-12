import 'package:flutter/material.dart';

class SalesListScreen extends StatefulWidget {
  const SalesListScreen({super.key});

  @override
  State<SalesListScreen> createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('All Sales'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              var result = await Navigator.pushNamed(context, '/sales/add');

              // if (result == true) {
              //   _productController.getProducts(setState);
              // }
            },
          ),
        ],
      ),
      // body: ,
    );
  }
}
