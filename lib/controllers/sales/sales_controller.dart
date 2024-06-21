import 'package:flutter/material.dart';
import 'package:flutter_pos/models/order.dart';
import 'package:flutter_pos/models/order_item.dart';
import 'package:flutter_pos/utils/sql_helper.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class SalesController extends GetxController {
  List<Order>? orders;
  DateTimeRange? selectedDateRange;

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

  void getOrders(Function setStateCallBack) async {
    try {
      var result = await sqlHelper.db!.rawQuery("""
  Select O.*,C.*,OPI.* from orders O
  Inner JOIN clients C
  On O.clientId = C.clientId
   Inner JOIN orderProductItems OPI
  On OPI.orderId = O.id
  """);
      print("all orders==============================>>>>>>>>$result");
      if (result.isNotEmpty) {
        orders = [];
        for (var item in result) {
          orders?.add(Order.fromJson(item));
        }
      } else {
        orders = [];
      }
    } catch (e) {
      orders = [];
      print('Error in get Orders $e');
    }

    setStateCallBack(() {});
  }

  void setSelectedDateRange(DateTimeRange dateRange) {
    selectedDateRange = dateRange;
    //  filterSales();
  }

  void clearSelectedDateRange() {
    selectedDateRange = null;
  }
}
