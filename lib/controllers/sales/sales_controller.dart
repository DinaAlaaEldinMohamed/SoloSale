import 'package:flutter/material.dart';
import 'package:flutter_pos/models/order.dart';
import 'package:flutter_pos/models/order_item.dart';
import 'package:flutter_pos/models/product.dart';
import 'package:flutter_pos/utils/app_utils.dart';
import 'package:flutter_pos/utils/sql_helper.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class SalesController extends GetxController {
  List<Order>? orders;
  List<Order>? clientOrders;
  List<Order>? filteredOrders;
  List<OrderItem>? orderItems;

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

//=========================get all orders ================
  Future<void> getOrders(Function setStateCallBack) async {
    try {
      var result = await sqlHelper.db!.rawQuery("""
  Select O.*,C.*,OPI.* , DATE(O.orderDate) as formated_date from orders O
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

  //=========================get  orderitems ================
  Future<void> getOrderItems(int orderId, Function setStateCallBack) async {
    try {
      var result = await sqlHelper.db!.rawQuery("""
  SELECT OPI.*, P.* FROM orderProductItems OPI
      INNER JOIN products P ON OPI.productId = P.productId
      WHERE OPI.orderId = '$orderId'
  """);
      print("(all order items)==============================>>>>>>>>$result");
      if (result.isNotEmpty) {
        orderItems = [];
        for (var item in result) {
          var orderItem = OrderItem.fromJson(item);
          orderItem.product = Product.fromJson(item);
          orderItems?.add(orderItem);
        }
      } else {
        orderItems = [];
      }
    } catch (e) {
      orderItems = [];
      print('Error in get Orders $e');
    }

    setStateCallBack(() {});
  }

//=========================get client orders=====================
  void getClientOrders(Function setStateCallBack, int clientId) async {
    try {
      var result = await sqlHelper.db!.rawQuery("""
  Select O.*,C.*,OPI.* from orders O
  Inner JOIN clients C
  On O.clientId = '$clientId'
   Inner JOIN orderProductItems OPI
  On OPI.orderId = O.id
  """);
      print("clients  orders==============================>>>>>>>>$result");
      if (result.isNotEmpty) {
        clientOrders = [];
        for (var item in result) {
          clientOrders?.add(Order.fromJson(item));
        }
      } else {
        clientOrders = [];
      }
    } catch (e) {
      clientOrders = [];
      print('Error in get clientOrders $e');
    }
  }

  //=========================filter sales =====================
  Future<void> filterSales(
    Function setStateCallBack, {
    DateTime? startDate,
    DateTime? endDate,
    int? clientId,
    String? salesCurrencyType,
  }) async {
    try {
      final queryBuilder = StringBuffer("""
      SELECT O.*, C.*, OPI.*
      FROM orders O
      INNER JOIN clients C ON O.clientId = C.clientId
      INNER JOIN orderProductItems OPI ON OPI.orderId = O.id
    """);

      final whereConditions = <String>[];

      if (clientId != null && clientId != 0) {
        whereConditions.add("O.clientId = $clientId");
      }
      if (startDate != null) {
        whereConditions.add("DATE(O.orderDate) >= '${formatDate(startDate)}'");
      }
      if (endDate != null) {
        whereConditions.add("DATE(O.orderDate) <= '${formatDate(endDate)}'");
      }
      if (salesCurrencyType != null) {
        if (salesCurrencyType != 'all') {
          whereConditions.add("O.paidCurrency = '$salesCurrencyType'");
        }
      }

      if (whereConditions.isNotEmpty) {
        queryBuilder.write(" WHERE ");
        queryBuilder.write(whereConditions.join(" AND "));
      }
      queryBuilder.write(" GROUP BY O.id");

      final result = await sqlHelper.db!.rawQuery(queryBuilder.toString());
      print("Filtered orders: $result");

      if (result.isNotEmpty) {
        filteredOrders = result.map((item) => Order.fromJson(item)).toList();
      } else {
        filteredOrders = [];
      }
    } catch (e) {
      filteredOrders = [];
      print('Error in get filteredOrders: $e');
    }
  }
}
