import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Util {
  static String getFormattedDate(DateTime dateTime) {
    return DateFormat('EEE, MMM d, y', 'en').format(dateTime);
  }

  static Widget getItem(dynamic iconData, int value, String units) {
    return Column(
      children: <Widget>[
        FaIcon(iconData, color: const Color(0xFF3478F6), size: 24),
        const SizedBox(height: 12),
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Color(0xFF14213D),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          units,
          style: const TextStyle(fontSize: 12, color: Color(0xFF78869B)),
        ),
      ],
    );
  }
}
