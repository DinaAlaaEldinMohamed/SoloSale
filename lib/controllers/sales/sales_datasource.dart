import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/models/order.dart';
import 'package:flutter_pos/models/product.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/widgets/products_widgets/product_details_bottom_sheet.dart';
import 'package:flutter_pos/widgets/sales/sales_card.dart';

class SalesDataSource extends DataTableSource {
  BuildContext? context;
  List<Order>? orders;
  SalesDataSource({
    required this.context,
    required this.orders,
  });
  @override
  DataRow? getRow(int index) {
    return DataRow2(cells: [
      DataCell(
          GestureDetector(
            child: SaleCard(
              order: orders?[index],
            ),
          ), onTap: () async {
        // await onViewProduct(orders![index], context);
      }),
      DataCell(
          GestureDetector(
            child: IntrinsicWidth(
              child: Container(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context!).size.width * 0.25,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${orders?[index].totalPrice}',
                      style: h5(
                        warningColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.unfold_more,
                      color: iconGrayColor,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
          onTap: () {}),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => orders?.length ?? 0;

  @override
  int get selectedRowCount => 0;
  Future<void> onViewProduct(Product product, context) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      builder: (_) {
        return ProductDetailsBottomSheet(
          product: product,
        );
      },
    );
  }
}
