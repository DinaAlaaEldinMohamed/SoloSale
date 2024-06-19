import 'package:flutter/material.dart';
import 'package:flutter_pos/models/product.dart';
import 'package:flutter_pos/utils/const.dart';

class ProductTile extends StatelessWidget {
  Product? product;
  ProductTile({this.product, super.key});

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
            child: Image.network(
              product?.image ?? '',
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Image.asset('assets/images/product.png');
              },
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${product?.productName}',
                    style: bodyText(primaryLightColor),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${product?.price}',
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
