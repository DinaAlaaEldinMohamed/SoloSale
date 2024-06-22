import 'package:flutter/material.dart';

import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/utils/sql_helper.dart';

import 'package:get_it/get_it.dart';

class CurrencyDropDown extends StatefulWidget {
  final void Function(String?)? onChanged;

  final String? selectedValue;

  const CurrencyDropDown(
      {required this.onChanged, this.selectedValue, super.key});

  @override
  State<CurrencyDropDown> createState() => _CurrencyDropDownState();
}

class _CurrencyDropDownState extends State<CurrencyDropDown> {
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
            : SizedBox(
                width: 60,
                height: 50,
                child: DropdownButton(
                  value: widget.selectedValue ?? 'EGP',
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: [
                    for (var currency in sqlIns.currencies!)
                      DropdownMenuItem(
                        value: currency.code,
                        child: Text(currency.code ?? 'No code'),
                      ),
                  ],
                  onChanged: widget.onChanged,
                  dropdownColor: primaryColor,
                  style: h6(whiteColor),
                  icon: const Icon(Icons.arrow_drop_down, color: whiteColor),
                ),
              );
  }
}
