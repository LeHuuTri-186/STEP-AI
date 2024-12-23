class ConvertDateTime {
  static String convertDateTime(DateTime dateTime) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    String day = twoDigits(dateTime.day);
    String month = twoDigits(dateTime.month);
    String year = twoDigits(dateTime.year % 100); // Last two digits of the year
    String hour = twoDigits(dateTime.hour);
    String minute = twoDigits(dateTime.minute);
    String second = twoDigits(dateTime.second);

    return '$day/$month/$year - $hour:$minute:$second';
  }
}
