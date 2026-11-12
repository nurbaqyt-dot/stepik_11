import 'package:flutter/material.dart';
import 'package:stepik_11/models/weather_forecast_daily.dart';

class TempView extends StatelessWidget {
  final AsyncSnapshot<WeatherForecast> snapshot;

  const TempView({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    var forecastList = snapshot.data!.list;
    var icon = forecastList[0].getIconUrl();
    var temp = forecastList[0].temp.day.toStringAsFixed(0);
    var description = forecastList[0].weather[0].description.toUpperCase();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.network(
          icon,
          width: 104,
          height: 104,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.wb_cloudy_rounded,
            color: Color(0xFFFFD36A),
            size: 78,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$temp °C',
              style: const TextStyle(
                fontSize: 54,
                height: 1,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: Color(0xFFD4E2FF),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
