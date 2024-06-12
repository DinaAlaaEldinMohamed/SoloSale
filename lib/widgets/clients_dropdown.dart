import 'package:flutter/material.dart';
import 'package:flutter_pos/controllers/clients/clients_controller.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:get/get.dart';

class ClientsDropDown extends StatefulWidget {
  final void Function(int?)? onChanged;
  final int? selectedValue;

  const ClientsDropDown(
      {required this.onChanged, this.selectedValue, super.key});

  @override
  State<ClientsDropDown> createState() => _ClientsDropDownState();
}

class _ClientsDropDownState extends State<ClientsDropDown> {
  final ClientController _clientController = Get.put(ClientController());

  @override
  void initState() {
    _clientController.getClients(setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _clientController.clients == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : (_clientController.clients?.isEmpty ?? false)
            ? const Center(
                child: Text('No Clients Found'),
              )
            : Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
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
                            icon: const Icon(Icons.arrow_forward_ios),
                            iconSize: 15,
                            underline: const SizedBox(),
                            hint: Text(
                              'Select Client',
                              style: bodyText(textPlaceholderColor),
                            ),
                            items: [
                              for (var client in _clientController.clients!)
                                DropdownMenuItem(
                                  value: client.clientId,
                                  child: Text(client.clientName ?? 'No Name'),
                                ),
                            ],
                            onChanged: widget.onChanged),
                      ),
                    ),
                  ),
                ],
              ); //DropdownButton(items: clients, onChanged:onChanged);
  }
}
