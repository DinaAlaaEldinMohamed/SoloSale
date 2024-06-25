import 'package:flutter/material.dart';
import 'package:flutter_pos/models/order_item.dart';
import 'package:flutter_pos/utils/const.dart';

// ignore: must_be_immutable
class OrderItemColumn extends StatefulWidget {
  String? selectedCurrency = 'EGP';
  double exchangeRate;
  List<OrderItem>? orderItems;

  OrderItemColumn(
      {this.selectedCurrency,
      this.exchangeRate = 1,
      this.orderItems,
      super.key});

  @override
  State<OrderItemColumn> createState() => _OrderItemColumnState();
}

class _OrderItemColumnState extends State<OrderItemColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text('Order Items',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16.0,
          )),
      for (var orderItem in widget.orderItems ?? [])
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            contentPadding: EdgeInsets.zero, // Removes horizontal padding
            dense: true, // Reduces the size of the ListTile
            visualDensity: const VisualDensity(
                horizontal: 0, vertical: -4), // Minimizes vertical padding
            leading: Image.network(
              orderItem.product.image ?? '',
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Image.asset('assets/images/product.png');
              },
            ),
            title: Text(
              '${orderItem.product.productName ?? 'No name'}',
              style: bodyText(Colors.black),
            ),
            subtitle: Text(
              '${(orderItem.productCount * orderItem.product.price).toStringAsFixed(2)} EGP\n${(orderItem.productCount * orderItem.product.price / widget.exchangeRate).toStringAsFixed(2)} ${widget.selectedCurrency}',
              style: bodyText(lightGreyColor),
            ),
            trailing: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${orderItem.productCount}x',
                  style: h6(primaryColor),
                )),
          ),
        ),
    ]);
  }
}
