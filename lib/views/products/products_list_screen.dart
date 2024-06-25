import 'package:flutter/material.dart';
import 'package:flutter_pos/controllers/product/product_controller.dart';
import 'package:flutter_pos/controllers/product/product_datasource.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/widgets/app_table.dart';
import 'package:flutter_pos/widgets/search_filter_icon.dart';
import 'package:get/get.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductController _productController = Get.put(ProductController());

  @override
  void initState() {
    _productController.getProducts(setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              var result = await Navigator.pushNamed(context, '/products/add');

              if (result == true) {
                _productController.getProducts(setState);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //SearchFilters(),
            //Search Bar
            Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  height: 44,
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: veryLightGrayColor),
                        ),
                        child: TextField(
                          onChanged: (value) async {
                            if (value == '') {
                              _productController.getProducts(setState);
                            } else {
                              _productController.searchProducts(value);
                            }
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: 'Search',
                            contentPadding: const EdgeInsets.all(0),
                            hintStyle: bodyText(iconGrayColor),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: iconGrayColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    //Barcode Icon
                    SearchFilterIcon(
                      icon: Icons.qr_code_scanner,
                      onPressed: () {
                        //widget.scanner(context);
                      },
                    ),
                    const SizedBox(width: 8),
                    //Sort Icon
                    SearchFilterIcon(
                      icon: Icons.sort,
                      onPressed: () {
                        // showModalBottomSheet(
                        //   isScrollControlled: true,
                        //   context: context,
                        //   shape: const RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.only(
                        //       topLeft: Radius.circular(4),
                        //       topRight: Radius.circular(4),
                        //     ),
                        //   ),
                        //   builder: (_) {
                        //     return const SortProductsBottomSheet();
                        //   },
                        //);
                      },
                    ),
                  ]),
                ),
              ),
              //=========product table header==============
              Container(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Product Name',
                      style: bodyText(lightGreyColor),
                    ),
                    Text(
                      'In Stock',
                      style: bodyText(warningColor),
                    ),
                  ],
                ),
              ),
              Divider(),
            ]),
            //=================Products Table============
            //header of table not displayed the header row is 0
            Expanded(
              child: AppTable(
                minWidth: 500,
                columns: const [
                  DataColumn(label: Text('Product Name')),
                  DataColumn(
                    label: Text(
                      'In stock',
                    ),
                  ),
                ],
                source: ProductDataSource(
                  context: context,
                  products: _productController.products,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
