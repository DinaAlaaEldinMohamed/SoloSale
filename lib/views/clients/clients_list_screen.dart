import 'package:flutter/material.dart';
import 'package:flutter_pos/controllers/clients/client_datasource.dart';
import 'package:flutter_pos/controllers/clients/clients_controller.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/widgets/app_table.dart';
import 'package:flutter_pos/widgets/search_filter_icon.dart';
import 'package:get/get.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({Key? key}) : super(key: key);

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  final ClientController _clientController = Get.put(ClientController());

  @override
  void initState() {
    _clientController.getClients(setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Clients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              var result = await Navigator.pushNamed(context, '/clients/add');

              if (result == true) {
                await _clientController.getClients(setState);
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //SearchFilters(),
            //Search Bar
            Column(children: [
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
                          onChanged: (value) async {
                            if (value == '') {
                              _clientController.getClients(setState);
                            } else {
                              _clientController.searchClients(value);
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
                    const SizedBox(width: 8),
                    //Sort Icon
                    SearchFilterIcon(
                      icon: Icons.sort,
                      onPressed: () {},
                    ),
                  ]),
                ),
              ),
              //=========client table header==============
              Container(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Client',
                      style: bodyText(lightGreyColor),
                    ),
                    Text(
                      'Sales Count',
                      style: bodyText(warningColor),
                    ),
                  ],
                ),
              ),
              const Divider(),
            ]),
            //=================Clients Table============
            //header of table not displayed the header row is 0
            Expanded(
              child: AppTable(
                minWidth: 500,
                columns: const [
                  DataColumn(label: Text('Client')),
                  DataColumn(
                    label: Text(
                      'Sales Count',
                    ),
                  ),
                ],
                source: ClientsDataSource(
                  context: context,
                  clients: _clientController.clients,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
