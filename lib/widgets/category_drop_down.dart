import 'package:flutter/material.dart';
import 'package:flutter_pos/controllers/category/category_controller.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:get/get.dart';

class CategoriesDropDown extends StatefulWidget {
  final void Function(int?)? onChanged;
  final int? selectedValue;

  const CategoriesDropDown(
      {required this.onChanged, this.selectedValue, super.key});

  @override
  State<CategoriesDropDown> createState() => _CategoryDropDownState();
}

class _CategoryDropDownState extends State<CategoriesDropDown> {
  final CategoryController _categoryController = Get.put(CategoryController());

  @override
  void initState() {
    _categoryController.getCategories(setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _categoryController.categories == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : (_categoryController.categories?.isEmpty ?? false)
            ? const Center(
                child: Text('No Categories Found'),
              )
            : Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: borderColor,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        child: DropdownButton(
                            value: widget.selectedValue,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Text(
                              'Select Category',
                              style: bodyText(textPlaceholderColor),
                            ),
                            items: [
                              for (var category
                                  in _categoryController.categories!)
                                DropdownMenuItem(
                                  value: category.id,
                                  child: Text(category.name ?? 'No Name'),
                                ),
                            ],
                            onChanged: widget.onChanged),
                      ),
                    ),
                  ),
                ],
              ); //DropdownButton(items: categories, onChanged:onChanged);
  }
}
