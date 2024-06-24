import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos/controllers/sales/sales_controller.dart';
import 'package:flutter_pos/models/client.dart';
import 'package:flutter_pos/models/currency.dart';
import 'package:flutter_pos/models/order.dart';
import 'package:flutter_pos/utils/app_utils.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/utils/sql_helper.dart';
import 'package:flutter_pos/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter_pos/widgets/buttons/custom_text_button.dart';
import 'package:flutter_pos/widgets/clients_dropdown.dart';
import 'package:flutter_pos/widgets/currency_dropDown.dart';
import 'package:flutter_pos/widgets/custom_text_field.dart';
import 'package:flutter_pos/widgets/dashed_line.dart';
import 'package:flutter_pos/widgets/order_item_dialog.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class SalesCrudScreen extends StatefulWidget {
  final Client? client;
  final Order? order;
  final Currency? currency;

  const SalesCrudScreen({this.client, this.order, this.currency, super.key});

  @override
  State<SalesCrudScreen> createState() => _SalesCrudScreenState();
}

class _SalesCrudScreenState extends State<SalesCrudScreen> {
  final SalesController _salesController = Get.put(SalesController());
  String formattedDate = '';
  int? selectedClientId;
  String? selectedCurrencyCode = 'EGP';
  TextEditingController? discountController;
  TextEditingController? commentController;
  bool showDiscountField = false;
  String? orderLabel;
  double totalPriceAfterDiscount = 0.0;
  double discountAmount = 0.0;
  double exchangeRate = 0.0;
  String exchangeRateText = '';
  double? orderTotalPrice;
  String msg = '';

  @override
  void initState() {
    commentController =
        TextEditingController(text: widget.order?.orderComment ?? '');
    initPage();
    super.initState();
  }

  void initPage() async {
    formattedDate = currentDateTime.toIso8601String();
    discountController =
        TextEditingController(text: '${widget.order?.discount ?? ''}');
    if (widget.order != null) {
      discountPercent();
      await _salesController.getOrderItems(widget.order?.id ?? 0, setState);
      selectedOrderItems = _salesController.orderItems;
      totalPriceAfterDiscount = widget.order?.totalPrice ?? 0;
    }
    discountController?.addListener(_updateDiscountDisplay);
    selectedClientId = widget.order?.clientId;
    selectedCurrencyCode = widget.order?.paidCurrency;
    if (widget.order == null) {
      showDiscountField = false;
    } else if (widget.order != null &&
        (widget.order?.discount != 0 || widget.order?.discount != null)) {
      discountAmount = widget.order?.discount ?? 0.0;
      showDiscountField = true;
    }
    orderLabel = widget.order == null
        ? '#OR${DateTime.now().millisecondsSinceEpoch}'
        : widget.order?.label;
    _displayExChangeRate();
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
        actions: [
          CurrencyDropDown(
            selectedValue: selectedCurrencyCode,
            onChanged: (value) {
              selectedCurrencyCode = value;
              _displayExChangeRate();
              setState(() {});
            },
          ),
        ],
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
                    exchangeRateText,
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
                orderItemColumn(
                    selectedCurrency: selectedCurrencyCode,
                    exchangeRate: exchangeRate),
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
                      style: bodyText(blackColor),
                    ),
                    Text(
                      '${(calculateTotalPrice! / exchangeRate).toStringAsFixed(2)}${selectedCurrencyCode ?? '$calculateTotalPrice  EGP'} ',
                      style: h6(blackColor),
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
                          fieldborderColor: mediumGrayColor,
                          labelText: 'Discount',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: discountController,
                          placeHolderTextColor: mediumGrayColor,
                        ),
                      )
                    : Container(),
                Column(
                  children: [
                    const SizedBox(height: 12),
                    const DashedLine(),
                    showDiscountField
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Discount :',
                                style: bodyText(blackColor),
                              ),
                              Text(
                                '${(discountAmount / exchangeRate).toStringAsFixed(2)} ${selectedCurrencyCode ?? '$discountAmount EGP'} ',
                                style: h6(blackColor),
                              ),
                            ],
                          )
                        : Container(),
                    const DashedLine(),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: primaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4)),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Paid : ${(totalPriceAfterDiscount / exchangeRate).toStringAsFixed(2)} ${selectedCurrencyCode ?? 'EGP'} ',
                            style: bodyText(primaryColor),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Remaining : 0 ${selectedCurrencyCode ?? 'EGP'} ',
                            style: bodyText(mediumGrayColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  fieldborderColor: mediumGrayColor,
                  labelText: 'Add Comment',
                  controller: commentController,
                  placeHolderTextColor: mediumGrayColor,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomElevatedButton(
                  backgroundColor: greenColor,
                  label: 'Confirm',
                  onPressed: () async {
                    if (selectedOrderItems == null) {
                      print('selectedOrderItems:null');
                    } else {
                      print('oderItems${selectedOrderItems?.length}');
                    }
                    await onSetOrder();
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
    );
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
      if (selectedClientId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'You Must Select Client First',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        return;
      }
      //add sale

      final order = Order.fromJson({
        'label': orderLabel,
        'totalPrice': totalPriceAfterDiscount,
        'discount': discountAmount,
        'clientId': selectedClientId,
        'paidCurrency': selectedCurrencyCode ?? 'EGP',
        'orderComment': commentController?.text ?? 'no comment',
        'orderDate': formattedDate
      });
      if (widget.order == null) {
        // add Order logic
        await _salesController.addOrder(order, selectedOrderItems);
        msg = 'Order Created Successfully';
      } else {
        //update Order Logic
        await _salesController.updateOrder(
            widget.order?.id, order, selectedOrderItems);
        msg = 'Order Updated Successfully';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            msg,
            style: const TextStyle(color: whiteColor),
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
            style: const TextStyle(color: whiteColor),
          ),
        ),
      );
    }
  }

  void discountPercent() {
    double? discount;

    var orderDiscountAmount = widget.order?.discount ?? 0.0;
    var totalprice = widget.order?.totalPrice ?? 0.0;
    discount = (orderDiscountAmount * 100) / (totalprice + orderDiscountAmount);
    String formattedDiscount = discount.toStringAsFixed(1);
    discountController?.text = formattedDiscount;
  }

  void _updateDiscountDisplay() {
    double discount = double.tryParse(discountController!.text) ?? 0.0;
    discountAmount = calculateTotalPrice! * (discount / 100);
    discountAmount = double.parse(discountAmount.toStringAsFixed(2));
    totalPriceAfterDiscount = calculateTotalPrice! - discountAmount;

    setState(() {});
  }

  void _displayExChangeRate() async {
    exchangeRate = await GetIt.I
        .get<SqlHelper>()
        .exchangeRate(targetCurrency: selectedCurrencyCode ?? 'EGP');

    exchangeRateText = '1 ${selectedCurrencyCode ?? 'EGP'} = $exchangeRate EGP';

    setState(() {});
  }

  Widget orderItemColumn(
      {String? selectedCurrency = 'EGP', double exchangeRate = 1}) {
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
            leading: Image.network(
              orderItem.product.image ?? '',
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Image.asset('assets/images/product.png');
              },
            ),
            title: Text(
              '${orderItem.product.productName ?? 'No name'}',
              style: bodyText(Colors.black),
            ),
            subtitle: Text(
              '${(orderItem.productCount * orderItem.product.price).toStringAsFixed(2)} EGP\n${(orderItem.productCount * orderItem.product.price / exchangeRate).toStringAsFixed(2)} $selectedCurrency',
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

  double? get calculateTotalPrice {
    var totalPrice = 0.0;
    if (orderItemsChanged) {
      for (var orderItem in selectedOrderItems ?? []) {
        totalPrice = totalPrice +
            (orderItem?.productCount ?? 0) * (orderItem?.product?.price ?? 0);
      }
      return totalPrice;
    } else {
      totalPrice = widget.order?.totalPrice ?? 0 + discountAmount;

      return totalPrice;
    }
  }
}
