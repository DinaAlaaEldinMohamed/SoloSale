import 'package:flutter/material.dart';
import 'package:flutter_pos/models/order.dart';

import 'package:flutter_pos/utils/const.dart';

// ignore: must_be_immutable
class SaleCard extends StatelessWidget {
  Order? order;
  SaleCard({this.order, super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: secondaryButtonColor,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(1),
              child: Icon(Icons.person)),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${order?.label}',
                    style: bodyText(primaryLightColor),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${order?.totalPrice}',
                    style: bodyText(lightGrayColor),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
        ],
      ),
      // ],
      //),
    );
  }
}
