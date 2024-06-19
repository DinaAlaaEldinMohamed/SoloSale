import 'package:flutter/material.dart';
// Assume you have a method to get exchange rates: getExchangeRate(currencyCode)

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  String? selectedCurrency;
  double? exchangeRate;
  double basePrice = 100.0; // Your base price
  double? totalPrice;

  List<String> currencies = ['USD', 'EUR', 'JPY']; // Your currency list

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DropdownButton<String>(
          value: selectedCurrency,
          onChanged: (String? newValue) async {
            exchangeRate = await getExchangeRate(newValue);
            setState(() {
              selectedCurrency = newValue;
              totalPrice = basePrice * exchangeRate!;
            });
          },
          items: currencies.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        if (totalPrice != null) Text('Total: $totalPrice $selectedCurrency'),
      ],
    );
  }

  // Mock method to simulate fetchng exchange rates
  Future<double> getExchangeRate(String? currencyCode) async {
    // Replace with your actual method of fetching exchange rates
    return Future.delayed(Duration(seconds: 1), () {
      return 0.93; // Example rate
    });
  }
}
