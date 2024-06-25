String formatDate(DateTime date) {
  final formattedDate =
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  return formattedDate;
}

final currentDateTime = DateTime.now();
String formatStringDate(String? inputDate) {
  try {
    final parsedDate = DateTime.parse(inputDate ?? '');
    final formattedDate =
        '${parsedDate.day.toString().padLeft(2, '0')}.${parsedDate.month.toString().padLeft(2, '0')}.${parsedDate.year}';
    return formattedDate;
  } catch (e) {
    print('Error parsing date: $e');
    return '';
  }
}

String formatTime(String dateStr) {
  try {
    DateTime parsedDateTime = DateTime.parse(dateStr);
    String formattedHour = parsedDateTime.hour.toString().padLeft(2, '0');
    String formattedMinute = parsedDateTime.minute.toString().padLeft(2, '0');
    String formattedTime = "$formattedHour:$formattedMinute ";
    formattedTime += parsedDateTime.hour < 12 ? "am" : "pm";
    return formattedTime;
  } catch (e) {
    return "Invalid date format. Please provide a valid ISO date string.";
  }
}

String formatNumber(double value, {int decimalPlaces = 2}) {
  return value.toStringAsFixed(decimalPlaces);
}
