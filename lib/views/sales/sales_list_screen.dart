import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pos/controllers/sales/sales_controller.dart';
import 'package:flutter_pos/controllers/sales/sales_datasource.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/widgets/app_table.dart';
import 'package:flutter_pos/widgets/clients_dropdown.dart';
import 'package:flutter_pos/widgets/sales/sales_date_filter.dart';
import 'package:flutter_pos/widgets/sales/sales_type_dropdown.dart';
import 'package:get/get.dart';

class SalesListScreen extends StatefulWidget {
  const SalesListScreen({super.key});

  @override
  State<SalesListScreen> createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  final SalesController _salesController = Get.put(SalesController());

  int? selectedClientId;
  String? selectedSalesFliterType = "all";
  @override
  void initState() {
    _salesController.getOrders(setState);
    // TODO: implement initState
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
              var result = await Navigator.pushNamed(context, '/sales/add');
              // if (result == true) {
              //   _productController.getProducts(setState);
              // }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ClientsDropDown(
                  hintText: 'All Clients',
                  selectedValue: selectedClientId,
                  onChanged: (value) {
                    selectedClientId = value;
                    setState(() {});
                  },
                  icon: Icons.arrow_drop_down,
                ),
              ),
              const Expanded(
                child: SalesDateFilter(),
              ),
              Expanded(
                  child: SalesTypeDropDown(
                hintText: 'All Sales',
                selectedValue: selectedSalesFliterType,
                onChanged: (value) {
                  selectedSalesFliterType = value;
                  setState(() {});
                },
                icon: Icons.arrow_drop_down,
              ))
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Label ',
                  style: bodyText(lightGrayColor),
                ),
                Text(
                  'Total Price',
                  style: bodyText(warningColor),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: AppTable(
              minWidth: 500,
              columns: const [
                DataColumn(label: Text('Order Label')),
                DataColumn(
                  label: Text(
                    'Total Price',
                  ),
                ),
              ],
              source: SalesDataSource(
                context: context,
                orders: _salesController.orders,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
