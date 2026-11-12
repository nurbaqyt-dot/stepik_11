import 'package:flutter/material.dart';
import 'package:stepik_11/models/weather_forecast_daily.dart';
import 'package:stepik_11/utilities/forecast_util.dart';

class CityView extends StatelessWidget {
  final AsyncSnapshot<WeatherForecast> snapshot;

  const CityView({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    var forecastList = snapshot.data!.list;
    var city = snapshot.data!.city.name;
    var country = snapshot.data!.city.country;
    var formattedDate = DateTime.fromMillisecondsSinceEpoch(
      forecastList[0].dt * 1000,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$city, $country',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 23,
            color: Colors.white,
            letterSpacing: -0.35,
          ),
        ),
        Text(
          Util.getFormattedDate(formattedDate),
          style: const TextStyle(fontSize: 14, color: Color(0xFFD4E2FF)),
        ),
      ],
    );
  }
}
