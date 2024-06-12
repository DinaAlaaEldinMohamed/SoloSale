import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/models/category.dart';

class CategoryDataSource extends DataTableSource {
  List<Category>? categories;
  void Function(Category)? onUpdate;
  void Function(Category)? onDelete;
  CategoryDataSource(
      {required this.categories,
      required this.onDelete,
      required,
      required this.onUpdate});
  @override
  DataRow? getRow(int index) {
    return DataRow2(cells: [
      DataCell(Text('${categories?[index].id}')),
      DataCell(Text('${categories?[index].name}')),
      DataCell(Text('${categories?[index].description}')),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              onUpdate!(categories![index]);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Color.fromARGB(255, 4, 80, 186),
            ),
            onPressed: () {
              onDelete!(categories![index]);
            },
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => categories?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
