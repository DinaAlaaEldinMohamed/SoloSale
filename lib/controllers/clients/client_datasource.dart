import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/models/client.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/widgets/clients/client_details_bottomsheet.dart';
import 'package:flutter_pos/widgets/clients/client_tile.dart';

class ClientsDataSource extends DataTableSource {
  BuildContext? context;
  List<Client>? clients;
  ClientsDataSource({
    required this.context,
    required this.clients,
  });
  @override
  DataRow? getRow(int index) {
    return DataRow2(cells: [
      DataCell(
          GestureDetector(
            child: ClientTile(
              client: clients?[index],
            ),
          ), onTap: () async {
        await onViewClient(clients![index], context);
      }),
      DataCell(
          GestureDetector(
            child: IntrinsicWidth(
              child: Container(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context!).size.width * 0.25,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3',
                      //  '${clients?[index].stock}',
                      style: h5(
                        warningColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.unfold_more,
                      color: iconGrayColor,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
          onTap: () {}),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => clients?.length ?? 0;

  @override
  int get selectedRowCount => 0;
  Future<void> onViewClient(Client client, context) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      builder: (_) {
        return ClientDetailsBottonSheet(
          client: client,
        );
      },
    );
  }
}
