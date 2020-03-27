import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatTime(Timestamp time) {
  if (time == null) {
    return '';
  }
  final dateTime = time.toDate();
  return DateFormat('yyyy-MM-dd kk:mm').format(dateTime);
}
