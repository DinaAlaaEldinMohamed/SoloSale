import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/controllers/category/category_controller.dart';
import 'package:flutter_pos/controllers/category/category_datasource.dart';
import 'package:flutter_pos/models/category.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/utils/sql_helper.dart';
import 'package:flutter_pos/views/categories/category_ops.dart';
import 'package:flutter_pos/widgets/products_widgets/product_details_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final CategoryController _categoryController = Get.put(CategoryController());
  @override
  void initState() {
    _categoryController.getCategories(setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              var result =
                  await Navigator.pushNamed(context, '/categories/add');
              if (result == true) {
                _categoryController.getCategories(setState);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: const IconThemeData(color: Colors.black, size: 26),
          ),
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
                builder: (_) => ProductDetailsBottomSheet(),
              );
            },
            child: PaginatedDataTable2(
                onPageChanged: (index) {
                  // print
                },
                // availableRowsPerPage: const <int>[1],
                hidePaginator: false,
                empty: const Center(
                  child: Text('No Data Found'),
                ),
                minWidth: 600,
                fit: FlexFit.tight,
                isHorizontalScrollBarVisible: true,
                rowsPerPage: 15,
                horizontalMargin: 20,
                checkboxHorizontalMargin: 12,
                columnSpacing: 20,
                wrapInCard: false,
                renderEmptyRowsInTheEnd: false,
                headingTextStyle:
                    const TextStyle(color: primaryColor, fontSize: 18),
                headingRowColor: MaterialStatePropertyAll(
                    Theme.of(context).primaryColorLight),
                border: TableBorder.all(color: Colors.grey),
                columns: const [
                  DataColumn(label: Text('Id')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Actions')),
                ],
                source: CategoryDataSource(
                  categories: _categoryController.categories,
                  onDelete: (category) async {
                    await onDeleteCategory(category);
                    // _categoryController.getCategories;
                  },
                  onUpdate: (category) async {
                    var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => AddCategory(
                                  category: category,
                                )));

                    if (result ?? false) {
                      _categoryController.getCategories(setState);
                    }
                  },
                )),
          ),
        ),
      ),
    );
  }

  Future<void> onDeleteCategory(Category category) async {
    try {
      var dialogResult = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete Category'),
              content:
                  const Text('Are you sure you want to delete this category?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          });

      if (dialogResult ?? false) {
        var sqlHelper = GetIt.I.get<SqlHelper>();
        await sqlHelper.db!
            .delete('categories', where: 'id =?', whereArgs: [category.id]);
        _categoryController.categories;
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error in deleting category ${category.name}')));
    }
  }
}
