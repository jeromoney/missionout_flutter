import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTime(Timestamp time) {
  if (time == null) {
    return '';
  }
  final dateTime = time.toDate();
  return DateFormat('MM-dd kk:mm').format(dateTime);
}
