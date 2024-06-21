String formatDate(DateTime date) {
  final formattedDate =
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  return formattedDate;
}

final currentDateTime = DateTime.now();
