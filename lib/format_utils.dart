String formatDate(DateTime datetime) {
  var values = [
    datetime.year,
    datetime.month,
    datetime.day,
  ].map((e) => e.toString().padLeft(2, '0'));
  return values.join('-');
}

String formatTime(DateTime datetime) {
  var values = [
    datetime.hour,
    datetime.minute,
    datetime.second,
  ].map((e) => e.toString().padLeft(2, '0'));
  return values.join(':');
}
