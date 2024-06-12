import 'package:flutter/material.dart';
import 'package:flutter_pos/controllers/product/product_controller.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/widgets/search_filter_icon.dart';
import 'package:get/get.dart';

class SearchFilters extends StatefulWidget {
  SearchFilters({super.key});

  @override
  State<SearchFilters> createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
  final ProductController _productController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
                  // controller: _searchController,
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
            SearchFilterIcon(
              icon: Icons.qr_code_scanner,
              onPressed: () {
                //widget.scanner(context);
              },
            ),
            const SizedBox(width: 8),
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
      Container(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Product Name'.tr,
              style: bodyText(lightGrayColor),
            ),
            Text(
              'In Stock'.tr,
              style: bodyText(warningColor),
            ),
          ],
        ),
      ),
      Divider(),
    ]);
  }
}
