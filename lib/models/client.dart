class Client {
  int? clientId;
  String? clientName;
  String? clientEmail;
  String? clientPhone;
  String? clientAddress;
  int? clientOrdersCount;

  Client();

  Client.fromJson(Map<String, dynamic> json) {
    clientId = json['clientId'];
    clientName = json['clientName'];
    clientEmail = json['clientEmail'];
    clientPhone = json['clientPhone'];
    clientAddress = json['clientAddress'];
    clientOrdersCount = json['clientOrdersCount'];
  }

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'clientName': clientName,
      'clientEmail': clientEmail,
      'clientPhone': clientPhone,
      'clientAddress': clientAddress
    };
  }

  Map<String, dynamic> utoJson() {
    return {
      'clientName': clientName,
      'clientEmail': clientEmail,
      'clientPhone': clientPhone,
      'clientAddress': clientAddress
    };
  }
}
