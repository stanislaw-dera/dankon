extension DateOnlyCompare on DateTime {
  bool isTheSameDate(DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }
}