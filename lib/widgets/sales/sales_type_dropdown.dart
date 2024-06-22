import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/utils/sql_helper.dart';
import 'package:get_it/get_it.dart';

class SalesTypeDropDown extends StatefulWidget {
  final void Function(String?)? onChanged;
  final String? selectedValue;
  final IconData? icon;
  final String hintText;
  const SalesTypeDropDown(
      {required this.onChanged,
      this.selectedValue,
      this.icon = Icons.arrow_forward_ios,
      this.hintText = 'All Sales',
      super.key});

  @override
  State<SalesTypeDropDown> createState() => _SalesTypeDropDownState();
}

class _SalesTypeDropDownState extends State<SalesTypeDropDown> {
  var sqlIns = GetIt.I.get<SqlHelper>();

  @override
  void initState() {
    sqlIns.getCurrencies(setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return sqlIns.currencies == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : (sqlIns.currencies?.isEmpty ?? false)
            ? const Center(
                child: Text('No Currencies Found'),
              )
            : Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: buttonBorderColor,
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
                      icon: Icon(widget.icon),
                      iconSize: 15,
                      underline: const SizedBox(),
                      hint: Text(
                        widget.hintText,
                        style: bodyText(mediumGrayColor),
                      ),
                      items: dropdownItems,
                      onChanged: widget.onChanged),
                ),
              );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    return [
      const DropdownMenuItem(value: "all", child: Text("All Sales")),
      for (var currency in sqlIns.currencies!)
        DropdownMenuItem(
          value: currency.code,
          child: Text(currency.code ?? 'No code'),
        ),
    ];
  }
}
