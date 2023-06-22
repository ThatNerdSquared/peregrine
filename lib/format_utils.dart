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

List<String> findTags(String input) {
  var findTags = RegExp(r'#[^\s]+');
  return findTags.allMatches(input).toList().map((e) => e[0]!).toList();
}

List<String> findContacts(String input) {
  var findContacts = RegExp(r'@[^\s]+');
  return findContacts.allMatches(input).map((e) => e[0]!).toList();
}