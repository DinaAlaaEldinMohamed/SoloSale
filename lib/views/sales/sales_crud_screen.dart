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
  @override
  void initState() {
    formattedDate = currentDateTime.toIso8601String();
    discountController =
        TextEditingController(text: '${widget.order?.discount ?? ''}');
    commentController =
        TextEditingController(text: widget.order?.orderComment ?? '');
    discountController?.addListener(_updateDiscountDisplay);
    selectedClientId = widget.order?.clientId;
    selectedCurrencyCode = widget.currency?.code;

    orderLabel = widget.order == null
        ? '#OR${DateTime.now().millisecondsSinceEpoch}'
        : widget.order?.label;
    _displayExChangeRate();
    super.initState();
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
                    '${exchangeRateText ?? ''}',
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
                      '$calculateTotalPrice ${selectedCurrencyCode ?? 'EGP'} ',
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
                                '${discountAmount ?? '0'} $selectedCurrencyCode',
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
        'totalPrice': calculateTotalPrice,
        'discount': discountAmount,
        'clientId': selectedClientId,
        'paidCurrency': selectedCurrencyCode ?? 'EGP',
        'orderComment': commentController?.text ?? 'no comment',
        'orderDate': formattedDate
      });
      if (widget.order == null) {
        // add product logic
        await _salesController.addOrder(order, selectedOrderItems);
      }
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
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}
