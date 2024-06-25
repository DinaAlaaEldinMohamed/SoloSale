import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/const.dart';

// ignore: must_be_immutable
class AppTable extends StatelessWidget {
  final List<DataColumn> columns;
  final DataTableSource source;
  final double minWidth;
  final double dataRowHeight;
  bool wrapInCard;

  TableBorder? border = TableBorder.symmetric(
      inside: const BorderSide(color: veryLightGrayColor));
  AppTable(
      {required this.columns,
      required this.source,
      this.minWidth = 600,
      this.dataRowHeight = 100,
      this.border,
      this.wrapInCard = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: const IconThemeData(color: Colors.black, size: 26),
      ),
      child: PaginatedDataTable2(
        onPageChanged: (index) {
          // print
        },
        // availableRowsPerPage: const <int>[1],
        hidePaginator: false,
        empty: const Center(
          child: Text('No Data Found'),
        ),
        minWidth: minWidth,
        fit: FlexFit.tight,
        isHorizontalScrollBarVisible: true,
        rowsPerPage: 15,
        horizontalMargin: 10,
        checkboxHorizontalMargin: 12,
        dataRowHeight: dataRowHeight,
        // dataTextStyle: bodyText(lightGrayColor),
        columnSpacing: 10,
        wrapInCard: wrapInCard,
        renderEmptyRowsInTheEnd: false,
        headingTextStyle: const TextStyle(color: lightGreyColor, fontSize: 18),
        headingRowColor: const MaterialStatePropertyAll(whiteColor),
        headingRowHeight: 0,
        border: border,
        // headingRowDecoration:
        //     BoxDecoration(backgroundBlendMode: BlendMode.dstIn),
        columns: columns,
        source: source,
      ),
    );
  }
}
