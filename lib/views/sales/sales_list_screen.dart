import 'package:flutter/material.dart';
import 'package:flutter_pos/controllers/sales/sales_controller.dart';
import 'package:flutter_pos/controllers/sales/sales_datasource.dart';
import 'package:flutter_pos/models/order_item.dart';
import 'package:flutter_pos/utils/sql_helper.dart';
import 'package:flutter_pos/widgets/app_table.dart';
import 'package:flutter_pos/widgets/clients_dropdown.dart';
import 'package:flutter_pos/widgets/sales/sales_date_filter.dart';
import 'package:flutter_pos/widgets/sales/sales_type_dropdown.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

bool filterActive = false;
List<OrderItem>? orderItems;

class SalesListScreen extends StatefulWidget {
  const SalesListScreen({super.key});

  @override
  State<SalesListScreen> createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  final SalesController _salesController = Get.put(SalesController());

  int? selectedClientId;
  String? selectedSalesFliterType;

  @override
  void initState() {
    _salesController.getOrders(setState);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('All Sales'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              //  var result =
              await Navigator.pushNamed(context, '/sales/add');
              // if (result == true) {
              //   _productController.getProducts(setState);
              // }
            },
          ),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ClientsDropDown(
                  hintText: 'All Clients',
                  selectedValue: selectedClientId,
                  onChanged: (value) async {
                    if (value == 0) {
                      value = null;
                    }
                    selectedClientId = value;
                    if (selectedClientId != null && selectedClientId != 0) {
                      await _salesController.filterSales(setState,
                          clientId: selectedClientId ?? 0);
                      filterActive = true;
                    } else {
                      filterActive = false;
                      await _salesController.getOrders(setState);
                    }

                    setState(() {});
                  },
                  icon: Icons.arrow_drop_down,
                ),
              ),
              Expanded(
                child: SalesDateFilter(onTap: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    await _salesController.filterSales(setState,
                        startDate: picked.start, endDate: picked.end);

                    filterActive = true;
                  }
                  setState(() {});
                }),
              ),
              Expanded(
                  child: SalesTypeDropDown(
                selectedValue: selectedSalesFliterType,
                onChanged: (value) async {
                  selectedSalesFliterType = value;
                  await _salesController.filterSales(setState,
                      salesCurrencyType: selectedSalesFliterType);
                  filterActive = true;
                  setState(() {});
                },
                icon: Icons.arrow_drop_down,
              ))
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                //  child: Text('Order Label', style: bodyText(lightGrayColor)),
                color: Colors.amber,
              ),
              // Text(
              //   'Total Price',
              //   style: bodyText(warningColor),
              // ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: AppTable(
            wrapInCard: true,
            minWidth: MediaQuery.of(context).size.width,
            dataRowHeight: 400,
            columns: const [
              DataColumn(
                label: Text('Order Label'),
              ),
              // DataColumn(
              //   label: Text(
              //     'Total Price',
              //   ),
              // ),
            ],
            source: SalesDataSource(
              context: context,
              orders: filterActive == true
                  ? _salesController.filteredOrders
                  : _salesController.orders,
            ),
          ),
        ),
      ]),
    );
  }
}
