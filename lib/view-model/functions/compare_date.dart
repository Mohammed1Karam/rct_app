import 'package:timeago/timeago.dart' as timeago;

String timeDifferenceFromNow(String dateStr) {
  // Parse the input string into a DateTime object
  DateTime dateTime = DateTime.parse(dateStr);

  // Get the current date and time
  // ignore: unused_local_variable
  DateTime now = DateTime.now();

  // Use timeago to get the human-readable difference
  String difference = timeago.format(dateTime, locale: 'en_short');

  return difference;
}
