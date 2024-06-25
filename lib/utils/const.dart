import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF0057DA);
const Color primaryLightColor = Color.fromARGB(255, 104, 164, 255);
const Color grey0Color = Color(0xFFF5F5F5);
const Color whiteColor = Color(0xFFFFFFFF);
const Color borderColor = Color(0xFFE0E0E0);
const Color textPlaceholderColor = Color.fromARGB(218, 84, 140, 192);
const Color primaryUltraLightColor = Color(0xFFF0F5FF);
const Color iconGrayColor = Color(0xFFAAAAAA);
const Color warningColor = Color(0xFFFF7A00);
const Color lightGreyColor = Color(0xFF666666);
const Color veryLightGrayColor = Color.fromARGB(255, 220, 217, 217);
const Color secondaryButtonColor = Color.fromARGB(255, 219, 226, 244);
const Color greenColor = Colors.green;
const Color blackColor = Colors.black;
const Color mediumGrayColor = Color.fromARGB(255, 161, 160, 160);
const textGrayColor = Color(0xFFAAAAAA);
const Color grey1Color = Color(0xFFEEEEEE);
const Color redColor = Colors.red;
const Color buttonBorderColor = Color(0xFFE0E0E0);
const Color textDarkColor = Color(0xFF2B2B2B);
const Color greyColor = Colors.grey;
const Color yellowColor = Color(0xFFFFF2CC);

TextStyle bodyText(Color? color) {
  return TextStyle(
    fontFamily: 'Roboto',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: color,
  );
}

TextStyle h1(Color? color) {
  return TextStyle(
    fontFamily: 'Roboto',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
    fontSize: 18,
    color: color,
  );
}

TextStyle h5(Color? color) {
  return TextStyle(
    fontFamily: 'Roboto',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    fontSize: 18,
    color: color,
  );
}

TextStyle h6(Color? color) {
  return TextStyle(
    fontFamily: 'Roboto',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: color,
  );
}

//* Format currency
String formatCurrency(double amount, String value) {
  return '500000';
}

MaterialColor getMaterialColor(Color color) {
  final Map<int, Color> shades = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };
  return MaterialColor(color.value, shades);
}
