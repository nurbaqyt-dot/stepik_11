import 'package:flutter/material.dart';
import 'package:stepik_11/screens/weather_forecast_screen.dart';

/// Kept as a compatibility entry point for callers that used LocationScreen.
class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) => const WeatherForecastScreen();
}
