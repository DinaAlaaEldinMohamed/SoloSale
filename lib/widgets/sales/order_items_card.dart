import 'package:flutter/material.dart';
import 'package:flutter_pos/models/order.dart';
import 'package:flutter_pos/models/order_item.dart';
import 'package:flutter_pos/utils/const.dart';

// ignore: must_be_immutable
class OrderItemCard extends StatefulWidget {
  String? selectedCurrency = 'EGP';
  double exchangeRate;
  List<OrderItem>? orderItems;
  Order? order;

  OrderItemCard(
      {this.selectedCurrency,
      this.exchangeRate = 1,
      this.orderItems,
      this.order,
      super.key});

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      for (var orderItem in widget.order?.orderItems ?? [])
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
              contentPadding: EdgeInsets.zero, // Removes horizontal padding
              dense: true, // Reduces the size of the ListTile
              visualDensity: const VisualDensity(
                  horizontal: 0, vertical: -4), // Minimizes vertical padding
              title: Text(
                '${orderItem.product.productName ?? 'No name'}',
                style: bodyText(Colors.black),
              ),
              subtitle: Text(
                '${orderItem.productCount}* ${orderItem.product.price} EGP',
                style: bodyText(mediumGrayColor),
              ),
              trailing: Text(
                '${orderItem.productCount * orderItem.product.price} EGP',
                style: h6(mediumGrayColor),
              )),
        ),
    ]);
  }
}
