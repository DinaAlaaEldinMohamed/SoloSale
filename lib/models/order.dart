class Order {
  int? id;
  String? label;
  double? totalPrice;
  double? discount;
  int? clientId;
  String? clientName;
  String? clientphone;
  String? comment;

  Order();

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    totalPrice = json['totalPrice'];
    discount = json['discount'];
    clientId = json['clientId'];
    clientName = json['clientName'];
    clientphone = json['clientphone'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'totalPrice': totalPrice,
      'discount': discount,
      'clientId': clientId,
      'clientName': clientName,
    };
  }

  Map<String, dynamic> toJsonAddOrder() {
    return {
      'id': id,
      'label': label,
      'totalPrice': totalPrice,
      'discount': discount,
      'clientId': clientId,
    };
  }
}
