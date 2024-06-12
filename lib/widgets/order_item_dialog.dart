import 'package:flutter/material.dart';
import 'package:flutter_pos/controllers/product/product_controller.dart';
import 'package:flutter_pos/models/order_item.dart';
import 'package:flutter_pos/models/product.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/utils/sql_helper.dart';
import 'package:flutter_pos/widgets/custom_elevated_button.dart';
import 'package:flutter_pos/widgets/search_filter_icon.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

List<OrderItem>? selectedOrderItems;

class OrderItemsDialog extends StatefulWidget {
  const OrderItemsDialog({super.key});

  @override
  State<OrderItemsDialog> createState() => _OrderItemsDialogState();
}

class _OrderItemsDialogState extends State<OrderItemsDialog> {
  List<Product>? products;
  // List<Product>? fiteredProducts;

  final ProductController _productController = Get.put(ProductController());
  String? orderLabel;
  bool showSearchBar = false;
  @override
  void initState() {
    initPage();
    super.initState();
  }

  void initPage() async {
    products = await _productController.getProductList(setState);
    // Now we're sure that showSearchBar is assigned before being used
    showSearchBar = products?.isNotEmpty ?? false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Dialog.fullscreen(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              showSearchBar
                  ? SizedBox(
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
                                  products = await _productController
                                      .getProductList(setState);
                                } else {
                                  products = await _productController
                                      .filterProductsList(value);
                                }
                                showSearchBar = true;
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
                    )
                  : const Center(child: Text('No Data Found')),
              Expanded(
                child: ListView(
                  children: [
                    // SearchFilters(),
                    for (var product in products ?? [])
                      ListTile(
                        subtitle: getOrderItem(product.productId!) != null
                            ? Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        if (getOrderItem(product.productId!)!
                                                .productCount ==
                                            0) return;
                                        getOrderItem(product.productId!)!
                                                .productCount =
                                            getOrderItem(product.productId!)!
                                                    .productCount! -
                                                1;

                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.remove)),
                                  Text(
                                      '${getOrderItem(product.productId!)?.productCount}'),
                                  IconButton(
                                      onPressed: () {
                                        if (getOrderItem(product.productId!)!
                                                .productCount ==
                                            getOrderItem(product.productId!)!
                                                .product!
                                                .stock) return;
                                        getOrderItem(product.productId!)!
                                                .productCount =
                                            getOrderItem(product.productId!)!
                                                    .productCount! +
                                                1;

                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.add)),
                                ],
                              )
                            : SizedBox(),
                        leading: Image.network(product.image ?? ''),
                        title: Text(product.productName ?? 'No name'),
                        trailing: IconButton(
                            onPressed: () {
                              if (getOrderItem(product.productId!) != null) {
                                onRemoveOrderItem(product.productId!);
                              } else {
                                onAddOrderItem(product);
                              }
                              setState(() {});
                            },
                            icon: getOrderItem(product.productId!) == null
                                ? const Icon(Icons.add)
                                : const Icon(Icons.delete)),
                      )
                  ],
                ),
              ),
              CustomElevatedButton(
                  label: 'Back',
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    setState(() {});
                  })
            ],
          ),
        ),
      );
    });
  }

  Future<void> onSetOrder() async {
    try {
      if (selectedOrderItems == null ||
          (selectedOrderItems?.isEmpty ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'You Must Add Order Items First',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        return;
      }

      var sqlHelper = GetIt.I.get<SqlHelper>();

      var orderId = await sqlHelper.db!
          .insert('orders', conflictAlgorithm: ConflictAlgorithm.replace, {
        'label': orderLabel,
        'totalPrice': calculateTotalPrice,
        'discount': 0,
        'clientId': 1
      });

      var batch = sqlHelper.db!.batch();
      for (var orderItem in selectedOrderItems!) {
        batch.insert('orderProductItems', {
          'orderId': orderId,
          'productId': orderItem.productId,
          'productCount': orderItem.productCount,
        });
      }
      var result = await batch.commit();

      print('>>>>>>>> orderProductItems${result}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Order Created Successfully',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Error : $e',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  OrderItem? getOrderItem(int productId) {
    for (var orderItem in selectedOrderItems ?? []) {
      if (orderItem.productId == productId) {
        return orderItem;
      }
    }
    return null;
  }

  double? get calculateTotalPrice {
    var totalPrice = 0.0;
    for (var orderItem in selectedOrderItems ?? []) {
      totalPrice = totalPrice +
          (orderItem?.productCount ?? 0) * (orderItem?.product?.price ?? 0);
    }
    return totalPrice;
  }

  void onRemoveOrderItem(int productId) {
    for (var i = 0; i < (selectedOrderItems?.length ?? 0); i++) {
      if (selectedOrderItems![i].productId == productId) {
        selectedOrderItems!.removeAt(i);
      }
    }
  }

  void onAddOrderItem(Product product) {
    var orderItem = OrderItem();
    orderItem.product = product;
    orderItem.productCount = 1;
    orderItem.productId = product.productId;
    selectedOrderItems ??= [];
    selectedOrderItems!.add(orderItem);
    setState(() {});
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

Widget orderItemColumn() {
  return Column(children: [
    const Text('Order Items',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
        )),
    for (var orderItem in selectedOrderItems ?? [])
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          contentPadding: EdgeInsets.zero, // Removes horizontal padding
          dense: true, // Reduces the size of the ListTile
          visualDensity: const VisualDensity(
              horizontal: 0, vertical: -4), // Minimizes vertical padding
          leading: Image.network(orderItem.product.image ?? ''),
          title: Text(
            '${orderItem.product.productName ?? 'No name'}',
            style: bodyText(Colors.black),
          ),
          subtitle: Text(
            '${orderItem.productCount * orderItem.product.price} egp \n 40 usd',
            style: bodyText(lightGrayColor),
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
