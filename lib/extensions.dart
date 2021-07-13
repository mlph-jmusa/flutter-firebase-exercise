import 'package:flutter/material.dart';
import 'constants.dart';

extension DateTimeExtension on DateTime {
  String toFormatterString() {
    return formatDate(this);
  }
}

