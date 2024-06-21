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
}
