import 'package:flutter/material.dart';
import 'package:flutter_pos/models/client.dart';
import 'package:flutter_pos/models/order.dart';
import 'package:flutter_pos/utils/const.dart';

import 'package:flutter_pos/widgets/buttons/custom_text_button.dart';
import 'package:flutter_pos/widgets/clients_dropdown.dart';

import 'package:flutter_pos/widgets/dashed_line.dart';
import 'package:flutter_pos/widgets/order_item_dialog.dart';

class SalesCrudScreen extends StatefulWidget {
  final Client? client;
  final Order? order;
  const SalesCrudScreen({this.client, this.order, super.key});

  @override
  State<SalesCrudScreen> createState() => _SalesCrudScreenState();
}

class _SalesCrudScreenState extends State<SalesCrudScreen> {
  int? selectedClientId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          'New Sale',
          style: TextStyle(
            color: primaryUltraLightColor,
          ),
        ),
      ),
      body: Column(children: [
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
                    'USD',
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
                onPressed: () {},
              ),
              // const DashedSep(width: 2),
              Column(
                children: [
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${'discounted_price'}:',
                        style: bodyText(
                          Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
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
                        'USD',
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
      ]),
    );
  }

  // Future<void> onAddProducClicked() async {
  // await showDialog(
  //     context: context,
  //     builder: (ctx) {
  //       return StatefulBuilder(builder: (context, setStateEx) {
  //         return Dialog.fullscreen(
  //           child: (products?.isEmpty ?? false)
  //               ? const Center(child: Text('No Data Found'))
  //               : Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Column(
  //                     children: [
  //                       Expanded(
  //                         child: ListView(
  //                           children: [
  //                             for (var product in products!)
  //                               ListTile(
  //                                 subtitle: getOrderItem(
  //                                             product.productId!) !=
  //                                         null
  //                                     ? Row(
  //                                         children: [
  //                                           IconButton(
  //                                               onPressed: () {
  //                                                 if (getOrderItem(product
  //                                                             .productId!)!
  //                                                         .productCount ==
  //                                                     0) return;
  //                                                 getOrderItem(product
  //                                                             .productId!)!
  //                                                         .productCount =
  //                                                     getOrderItem(product
  //                                                                 .productId!)!
  //                                                             .productCount! -
  //                                                         1;

  //                                                 setStateEx(() {});
  //                                               },
  //                                               icon:
  //                                                   const Icon(Icons.remove)),
  //                                           Text(
  //                                               '${getOrderItem(product.productId!)?.productCount}'),
  //                                           IconButton(
  //                                               onPressed: () {
  //                                                 if (getOrderItem(product
  //                                                             .productId!)!
  //                                                         .productCount ==
  //                                                     getOrderItem(product
  //                                                             .productId!)!
  //                                                         .product!
  //                                                         .stock) return;
  //                                                 getOrderItem(product
  //                                                             .productId!)!
  //                                                         .productCount =
  //                                                     getOrderItem(product
  //                                                                 .productId!)!
  //                                                             .productCount! +
  //                                                         1;

  //                                                 setStateEx(() {});
  //                                               },
  //                                               icon: const Icon(Icons.add)),
  //                                         ],
  //                                       )
  //                                     : SizedBox(),
  //                                 leading: Image.network(product.image ?? ''),
  //                                 title:
  //                                     Text(product.productName ?? 'No name'),
  //                                 trailing: IconButton(
  //                                     onPressed: () {
  //                                       if (getOrderItem(
  //                                               product.productId!) !=
  //                                           null) {
  //                                         onRemoveOrderItem(
  //                                             product.productId!);
  //                                       } else {
  //                                         onAddOrderItem(product);
  //                                       }
  //                                       setStateEx(() {});
  //                                     },
  //                                     icon:
  //                                         getOrderItem(product.productId!) ==
  //                                                 null
  //                                             ? const Icon(Icons.add)
  //                                             : const Icon(Icons.delete)),
  //                               )
  //                           ],
  //                         ),
  //                       ),
  //                       CustomElevatedButton(
  //                           label: 'Back',
  //                           onPressed: () {
  //                             Navigator.of(context).pop();
  //                           })
  //                     ],
  //                   ),
  //                 ),
  //         );
  //       });
  //     });
  // setState(() {});
}
