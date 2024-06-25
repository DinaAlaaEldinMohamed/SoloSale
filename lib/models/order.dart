import 'package:flutter_pos/models/order_item.dart';

class Order {
  int? id;
  String? label;
  double? totalPrice;
  double? discount;
  int? clientId;
  String? clientName;
  String? clientphone;
  String? paidCurrency;
  String? orderComment;
  String? orderDate;
  String? formated_date;
  List<OrderItem>? orderItems;

  Order();

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    totalPrice = json['totalPrice'];
    discount = json['discount'];
    clientId = json['clientId'];
    clientName = json['clientName'];
    clientphone = json['clientphone'];
    paidCurrency = json['paidCurrency'];
    orderComment = json['orderComment'];
    orderDate = json['orderDate'];
    formated_date = json['formated_date'];
    if (json['orderItems'] != null) {
      orderItems = List<OrderItem>.from(
        json['orderItems'].map((item) => OrderItem.fromJson(item)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'totalPrice': totalPrice,
      'discount': discount,
      'clientId': clientId,
      'clientName': clientName,
      'paidCurrency': paidCurrency,
      'orderComment': orderComment,
      'orderDate': orderDate,
    };
  }

  Map<String, dynamic> toJsonAddOrder() {
    return {
      'id': id,
      'label': label,
      'totalPrice': totalPrice,
      'discount': discount,
      'clientId': clientId,
      'paidCurrency': paidCurrency,
      'orderComment': orderComment,
      'orderDate': orderDate,
    };
  }

  Map<String, dynamic> toJsonUpdateOrder() {
    return {
      'label': label,
      'totalPrice': totalPrice,
      'discount': discount,
      'clientId': clientId,
      'paidCurrency': paidCurrency,
      'orderComment': orderComment,
      'orderDate': orderDate,
    };
  }
}
