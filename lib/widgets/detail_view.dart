import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stepik_11/models/weather_forecast_daily.dart';
import 'package:stepik_11/utilities/forecast_util.dart';

class DetailView extends StatelessWidget {
  final AsyncSnapshot<WeatherForecast> snapshot;

  const DetailView({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    var forecastList = snapshot.data!.list;
    var pressure = forecastList[0].pressure;
    var humidity = forecastList[0].humidity;
    var wind = forecastList[0].speed;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE9EEF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 18),
            child: Text(
              'WEATHER DETAILS',
              style: TextStyle(
                color: Color(0xFF78869B),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Util.getItem(
                FontAwesomeIcons.temperatureThreeQuarters,
                pressure.round(),
                'hPa',
              ),
              Util.getItem(FontAwesomeIcons.cloudRain, humidity, '%'),
              Util.getItem(FontAwesomeIcons.wind, wind.toInt(), 'm/s'),
            ],
          ),
        ],
      ),
    );
  }
}
