import 'package:flutter_pos/models/client.dart';
import 'package:flutter_pos/utils/sql_helper.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

class ClientController extends GetxController {
  List<Client>? clients;
  var sqlHelper = GetIt.I.get<SqlHelper>();

  Future<void> getClients(Function setStateCallBack) async {
    try {
      final data = await sqlHelper.db!.query('clients');
      clients = [];
      if (data.isNotEmpty) {
        for (var item in data) {
          final client = Client.fromJson(item);
          final clientId = client.clientId;
          final orderCount = await getClientOrderCount(clientId);
          client.clientOrdersCount = orderCount;
          clients?.add(client);
        }
      } else {
        clients = [];
      }
    } catch (e) {
      clients = [];
      print('Error in getClients: $e');
    }
    setStateCallBack(() {});
  }

  Future<int> getClientOrderCount(int? clientId) async {
    try {
      final result = await sqlHelper.db!.rawQuery("""
      SELECT COUNT(O.id) AS clientOrdersCount
      FROM orders O
      WHERE O.clientId = $clientId
    """);

      if (result.isNotEmpty) {
        final count = result.first['clientOrdersCount'] as int;
        return count;
      } else {
        return 0; // No orders for this client
      }
    } catch (e) {
      print('Error in getClientOrderCount: $e');
      return 0;
    }
  }

  void searchClients(String text) async {
    try {
      clients = [];
      var data = await sqlHelper.db!.rawQuery("""
                Select * from clients 
                where clientName like '%$text%' OR clientPhone like '%$text%' 
                """);
      if (data.isNotEmpty) {
        clients = [];
        for (var item in data) {
          clients?.add(Client.fromJson(item));
        }
      } else {
        clients = [];
      }
    } catch (e) {
      clients = [];
      print('Error in get clients $e');
    }
  }

// add Client
  Future<void> addClient(Client client) async {
    await sqlHelper.db!.insert('clients', client.toJson());
  }

  //update Client
  Future<void> updateClient(Client client, int? clientId) async {
    await sqlHelper.db!.update('clients', client.utoJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
        where: 'clientId =?',
        whereArgs: [clientId]);
  }

  Future<void> detleteClient(Client client, int? clientId) async {
    await sqlHelper.db!
        .delete('clients', where: 'clientId =?', whereArgs: [client.clientId]);
  }

  Future<Object> filterClients(String searchText) async {
    //<Client> clients;
    if (searchText.isNotEmpty) {
      var data = await sqlHelper.db!.rawQuery("""
                Select * from clients 
                where clientName = $searchText'
                """).toString();
      return data;
    }
    return [];
  }
}
