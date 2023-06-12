import 'package:intl/intl.dart';

String getDate(int timestamp) {
  DateTime time = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final String formattedTime = DateFormat('yyyy/MM/dd   hh:mm a').format(time);
  return formattedTime;
}

