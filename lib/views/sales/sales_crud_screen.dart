import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos/models/client.dart';
import 'package:flutter_pos/models/order.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/utils/sql_helper.dart';
import 'package:flutter_pos/widgets/buttons/custom_elevated_button.dart';

import 'package:flutter_pos/widgets/buttons/custom_text_button.dart';
import 'package:flutter_pos/widgets/clients_dropdown.dart';
import 'package:flutter_pos/widgets/custom_text_field.dart';

import 'package:flutter_pos/widgets/dashed_line.dart';
import 'package:flutter_pos/widgets/order_item_dialog.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

class SalesCrudScreen extends StatefulWidget {
  final Client? client;
  final Order? order;
  const SalesCrudScreen({this.client, this.order, super.key});

  @override
  State<SalesCrudScreen> createState() => _SalesCrudScreenState();
}

class _SalesCrudScreenState extends State<SalesCrudScreen> {
  int? selectedClientId;
  TextEditingController? discountController;
  bool showDiscountField = false;
  String? orderLabel;
  @override
  void initState() {
    discountController =
        TextEditingController(text: '${widget.order?.discount ?? ''}');
    discountController?.addListener(_updateDiscountDisplay);
  }

  void _updateDiscountDisplay() {
    setState(() {});
    selectedClientId = widget.order?.clientId;
    orderLabel = widget.order == null
        ? '#OR${DateTime.now().millisecondsSinceEpoch}'
        : widget.order?.label;

    super.initState();
  }

  @override
  void dispose() {
    // Don't forget to dispose of the controller when the widget is removed
    discountController?.removeListener(_updateDiscountDisplay);
    discountController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          widget.order == null ? 'Add New Sale' : 'Update Sale',
          style: const TextStyle(
            color: primaryUltraLightColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Row(children: [
            Expanded(
              child: Container(
                height: 30,
                color: const Color(0xFFFFF2CC),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 5,
                  ),
                  child: Text(
                    '$orderLabel',
                    style: bodyText(warningColor),
                  ),
                ),
              ),
            )
          ]),
          //clients list
          Padding(
            padding: const EdgeInsets.all(20),
            child: ClientsDropDown(
              selectedValue: selectedClientId,
              onChanged: (value) {
                selectedClientId = value;
                setState(() {});
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: gray100Color,
              border: Border.all(
                color: const Color(0xFFE0E0E0),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                // ListView.builder(
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   //   itemCount: widget.sale.products.length,
                //   itemBuilder: (context, index) {
                //     //final product = widget.sale.products[index];

                //     return Container(
                //       margin: const EdgeInsets.only(bottom: 16.0),
                //       child: Row(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Expanded(
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Text(
                //                   'productname',
                //                   style: bodyText(
                //                     Theme.of(context).textTheme.bodyLarge!.color,
                //                   ),
                //                 ),
                //                 const SizedBox(height: 2),
                //                 const Text(
                //                   // _productController
                //                   //             .getProduct(product['id'])
                //                   //             .name ==
                //                   //         ''
                //                   //     ? formatCurrency(
                //                   //         product['price'],
                //                   //         _profileController
                //                   //             .user['mainCurrency'],
                //                   //       )
                //                   //     : formatCurrency(
                //                   //         _cartController.getPrice(
                //                   //           product['id'],
                //                   //         ),
                //                   //         _profileController
                //                   //             .user['mainCurrency'],
                //                   //       ),
                //                   'usd',
                //                   style: TextStyle(
                //                     color: Color(0xFF999999),
                //                     fontSize: 14,
                //                   ),
                //                 ),
                //                 const SizedBox(height: 2),
                //                 const Text(
                //                   // formatCurrency(
                //                   //     product['price'] /
                //                   //         Preferences
                //                   //             .getExchangeRateResult(),
                //                   //     _profileController
                //                   //         .user['secondaryCurrency']),
                //                   'usd',
                //                   style: TextStyle(
                //                     color: Color(0xFF999999),
                //                     fontSize: 14,
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //           const SizedBox(
                //             width: 4,
                //           ),
                //           GestureDetector(
                //             onTap: () {
                //               // _productController.getProduct(product['id']).id ==
                //               //         ''
                //               //     ? errorSnackbar('not_found'.tr)
                //               //     : showDialog(
                //               //         barrierDismissible: false,
                //               //         context: context,
                //               //         builder: (context) => AddToCartDialog(
                //               //           product: _productController
                //               //               .getProduct(product['id']),
                //               //           itemCounter: _cartController
                //               //               .singleProductQuantity(
                //               //                   product['id']),
                //               //           addition: product['quantity'],
                //               //         ),
                //               //       );
                //             },
                //             child: Container(
                //               padding: const EdgeInsets.symmetric(
                //                 vertical: 6,
                //                 horizontal: 8,
                //               ),
                //               decoration: BoxDecoration(
                //                 border: Border.all(
                //                   color: const Color(0xFFE0E0E0),
                //                   width: 1,
                //                 ),
                //                 borderRadius: BorderRadius.circular(4),
                //               ),
                //               child: Text(
                //                 // _productController
                //                 //             .getProduct(product['id'])
                //                 //             .name ==
                //                 //         ''
                //                 //     ? '${product['quantity']}x'
                //                 //     : '${_cartController.singleProductQuantity(
                //                 //         product['id'],
                //                 // )}x',
                //                 'product X',
                //                 style: h6(primaryLightColor)
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                // ),
                orderItemColumn(),
                CustomTextButton(
                  buttonLabel: 'Add Product',
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return const OrderItemsDialog();
                        });
                    setState(() {});
                  },
                ),

                const SizedBox(height: 2),
                const DashedLine(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total:',
                      style: bodyText(Colors.black),
                    ),
                    Text(
                      // chosenCurrency == _profileController.user['mainCurrency']
                      //     ? formatCurrency(
                      //         _cartController.productsPrice, chosenCurrency)
                      //     : formatCurrency(
                      //         _cartController.productsPrice /
                      //             Preferences.getExchangeRateResult(),
                      //         chosenCurrency),
                      '$calculateTotalPrice USD',
                      style: h6(
                        Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                  ],
                ),
                const DashedLine(),
                const SizedBox(height: 2),

                CustomTextButton(
                  buttonLabel: 'Add Discount',
                  onPressed: () {
                    showDiscountField = true;
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                showDiscountField
                    ? Form(
                        child: CustomTextField(
                          fieldborderColor: lightGrayColor,
                          labelText: 'Discount',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: discountController,
                        ),
                      )
                    : Container(),
                Column(
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        showDiscountField
                            ? Text(
                                'Discount :',
                                style: bodyText(
                                  Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                              )
                            : Container(),
                        Text(
                          // chosenCurrency ==
                          //         _profileController.user['mainCurrency']
                          //     ? formatCurrency(
                          //         _cartController.productsPrice -
                          //             _cartController.discount.value,
                          //         chosenCurrency)
                          //     : formatCurrency(
                          //         (_cartController.productsPrice -
                          //                 _cartController
                          //                     .discount.value) /
                          //             Preferences.getExchangeRateResult(),
                          //         chosenCurrency),
                          '${discountController?.text ?? ''} %',
                          style: h6(
                            Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CustomElevatedButton(
            backgroundColor: greenColor,
            label: 'Confirm',
            onPressed: () {},
          )
        ]),
      ),
    );
  }

  Future<void> onSetOrder() async {
    try {
      if (selectedOrderItems == null ||
          (selectedOrderItems?.isEmpty ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
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
        SnackBar(
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
}
