import 'package:flutter/material.dart';
import 'package:flutter_pos/controllers/sales/sales_controller.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:get/get.dart';

class SalesDateFilter extends StatefulWidget {
  const SalesDateFilter({super.key});

  @override
  State<SalesDateFilter> createState() => _SalesDateFilterState();
}

class _SalesDateFilterState extends State<SalesDateFilter> {
  final SalesController _salesController = Get.put(SalesController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() {
            _salesController.setSelectedDateRange(picked);
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Any Date',
              style: bodyText(
                mediumGrayColor,
              ),
            ),
            const Icon(
              Icons.expand_more,
              color: iconGrayColor,
            ),
          ],
        ),
      ),
    );
  }
}
