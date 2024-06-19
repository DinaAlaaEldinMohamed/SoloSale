class Currency {
  String? code; // Currency code (e.g., USD, EUR)
  String? name; // Currency name (e.g., US Dollar, Euro)
  String? symbol; // Currency symbol (e.g., $, €)

  // Currency({required this.code, required this.name, required this.symbol});
  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name, 'symbol': symbol};
  }

  Currency.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    symbol = json['symbol'];
  }
}
