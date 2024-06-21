import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/const.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      const DropdownMenuItem(value: "high", child: Text("High Sales")),
      const DropdownMenuItem(value: "low", child: Text("Low Sales")),
    ];
  }
}
