import 'package:flutter/material.dart';
import 'package:stepik_11/utilities/forecast_util.dart';

Widget forecastCard(AsyncSnapshot snapshot, int index) {
  var forecastList = snapshot.data!.list;
  DateTime date = DateTime.fromMillisecondsSinceEpoch(
    forecastList[index].dt * 1000,
  );
  var fullDate = Util.getFormattedDate(date);
  var dayOfWeek = fullDate.split(',')[0].toUpperCase();
  var tempMin = forecastList[index].temp.min.toStringAsFixed(0);
  var icon = forecastList[index].getIconUrl();

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Text(
        dayOfWeek,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF78869B),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
      const SizedBox(height: 8),
      Image.network(
        icon,
        width: 48,
        height: 48,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.wb_cloudy_rounded,
          color: Color(0xFF3478F6),
          size: 38,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        '$tempMin°',
        style: const TextStyle(
          fontSize: 21,
          color: Color(0xFF14213D),
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
    ],
  );
}
