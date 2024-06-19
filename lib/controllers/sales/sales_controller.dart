import 'package:flutter_pos/models/order.dart';
import 'package:flutter_pos/models/order_item.dart';
import 'package:flutter_pos/utils/sql_helper.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class SalesController extends GetxController {
  List<Order>? orders;

  var sqlHelper = GetIt.I.get<SqlHelper>();
  Future<void> addOrder(
      Order order, List<OrderItem>? selectedOrderItems) async {
    var orderId = await sqlHelper.db!.insert('orders', order.toJsonAddOrder());
    var batch = sqlHelper.db!.batch();
    for (var orderItem in selectedOrderItems!) {
      batch.insert('orderProductItems', {
        'orderId': orderId,
        'productId': orderItem.productId,
        'productCount': orderItem.productCount,
      });
    }
    var result = await batch.commit();

    print('>>>>>>>> orderProductItems${result}');
  }
}
