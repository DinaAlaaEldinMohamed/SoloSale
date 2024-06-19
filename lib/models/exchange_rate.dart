class ExchangeRate {
  final String baseCurrency;
  final String targetCurrency;
  final double rate;

  ExchangeRate(
      {required this.baseCurrency,
      required this.targetCurrency,
      required this.rate});
  Map<String, dynamic> toJson() {
    return {
      'baseCurrency': baseCurrency,
      'targetCurrency': targetCurrency,
      'rate': rate
    };
  }
}
