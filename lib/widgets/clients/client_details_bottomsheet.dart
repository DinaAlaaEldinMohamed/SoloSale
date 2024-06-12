import 'package:flutter/material.dart';
import 'package:flutter_pos/controllers/clients/clients_controller.dart';
import 'package:flutter_pos/models/client.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/views/clients/client_crud_screen.dart';
import 'package:flutter_pos/widgets/buttons/secondary_button.dart';
import 'package:flutter_pos/widgets/products_widgets/product_row.dart';
import 'package:get/get.dart';

class ClientDetailsBottonSheet extends StatefulWidget {
  Client? client;
  ClientDetailsBottonSheet({this.client, super.key});

  @override
  State<ClientDetailsBottonSheet> createState() =>
      _ClientDetailsBottonSheetState();
}

class _ClientDetailsBottonSheetState extends State<ClientDetailsBottonSheet> {
  final ClientController _clientController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 5,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: primaryLightColor,
                    child: Text(
                        '${widget.client?.clientName?[0].toUpperCase() ?? 'C'}'),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.client?.clientName ?? '',
                          style: h1(Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Phone: ${widget.client?.clientPhone ?? ''}',
                          style: bodyText(lightGrayColor),
                        ),
                        const Divider(),
                        //product code row
                        CustomRow(
                            label: 'Email',
                            value: '${widget.client?.clientEmail}',
                            style: h6(Colors.black)),
                        //in stock row
                        CustomRow(
                          label: 'Address',
                          value:
                              '${widget.client?.clientAddress ?? 'Not defined'}',
                          style: h6(primaryLightColor),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: veryLightGrayColor),
                    ),
                    child: IconButton(
                      onPressed: () {
                        onDeletePorduct(widget.client!);
                      },
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: SecondaryButton(
                          backgroundColor: primaryColor,
                          textColor: whiteColor,
                          label: 'Edit CLient',
                          onPressed: () async {
                            var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => ClientCrudScreen(
                                          client: widget.client,
                                        )));

                            if (result ?? false) {
                              _clientController.getClients(setState);
                            }
                          })),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> onDeletePorduct(Client client) async {
    try {
      var dialogResult = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete Client'),
              content:
                  const Text('Are you sure you want to delete this client?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          });

      if (dialogResult ?? false) {
        _clientController.detleteClient(client, client.clientId);
        _clientController.clients;
        Navigator.popAndPushNamed(context, '/clients');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text(
                'Deleting Client: ${client.clientName} Done Sucessfully')));
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error in deleting client: ${client.clientName}')));
    }
  }
}
