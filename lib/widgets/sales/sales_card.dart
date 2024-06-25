import 'package:flutter/material.dart';
import 'package:flutter_pos/models/order.dart';
import 'package:flutter_pos/models/order_item.dart';
import 'package:flutter_pos/utils/app_utils.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/utils/sql_helper.dart';
import 'package:flutter_pos/widgets/sales/order_items_card.dart';
import 'package:flutter_pos/widgets/sales/sales_actions.dart';
import 'package:get_it/get_it.dart';

// ignore: must_be_immutable
class SaleCard extends StatefulWidget {
  Order? order;
  List<OrderItem>? orderItems;

  SaleCard({this.order, this.orderItems, super.key});

  @override
  State<SaleCard> createState() => _SaleCardState();
}

class _SaleCardState extends State<SaleCard> {
  double exchangeRate = 1;

  // final SalesController _salesController = Get.put(SalesController());

  @override
  void initState() {
    // TODO: implement initState
    // initCard();
    super.initState();
  }

  initCard() async {
    exchangeRate = await GetIt.I
        .get<SqlHelper>()
        .exchangeRate(targetCurrency: widget.order?.paidCurrency ?? 'EGP');
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 40,
              color: yellowColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                        child: Text(
                      formatStringDate(widget.order?.formated_date),
                      style: h6(blackColor),
                    )),
                    Expanded(
                      child: Text(
                        'Total:${formatNumber(widget.order?.totalPrice ?? 0, decimalPlaces: 3)}',
                        style: h6(mediumGrayColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
              margin: const EdgeInsets.only(right: 16, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '${'Reciept'}: ${formatTime(widget.order?.orderDate ?? '')}',
                        style: h6(
                          Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                      const Spacer(),
                      const SalesActions(),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 30,
                        color: iconGrayColor,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${widget.order?.clientName}',
                          style: bodyText(mediumGrayColor),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                    ],
                  ),
                  Text(
                    '_  ' * 32,
                    style: const TextStyle(color: textDarkColor, fontSize: 11),
                  ),
                  OrderItemCard(
                    selectedCurrency: widget.order?.paidCurrency,
                    // orderItems: widget.orderItems,
                    exchangeRate: exchangeRate,
                    order: widget.order,
                  ),
                  Text(
                    '_  ' * 32,
                    style: const TextStyle(color: textDarkColor, fontSize: 11),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Spacer(),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total:${formatNumber(widget.order?.totalPrice ?? 0 + (widget.order?.discount ?? 0))} ${widget.order?.paidCurrency}',
                            style: h5(blackColor),
                          ),
                          Text(
                            'Paid',
                            style: bodyText(greenColor),
                          )
                        ],
                      )),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      // ],
      //),
    );
  }
}
