import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/models/order.dart';
import 'package:flutter_pos/models/order_item.dart';
import 'package:flutter_pos/views/sales/sales_crud_screen.dart';
import 'package:flutter_pos/widgets/sales/sales_card.dart';

class SalesDataSource extends DataTableSource {
  BuildContext? context;
  List<Order>? orders;
  List<OrderItem>? orderItems;

  SalesDataSource(
      {required this.context, required this.orders, this.orderItems});
  @override
  DataRow? getRow(int index) {
    return DataRow2(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.transparent)),
        cells: [
          DataCell(
              GestureDetector(
                child: SingleChildScrollView(
                  child: SaleCard(
                    order: orders?[index],
                    // orderItems: orderItems,
                  ),
                ),
              ), onTap: () async {
            // await onViewProduct(orders![index], context);

            await Navigator.push(
                context!,
                MaterialPageRoute(
                    builder: (ctx) => SalesCrudScreen(
                          order: orders?[index],
                        )));
          }),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => orders?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
