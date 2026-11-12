import 'package:stepik_11/api/weather_api.dart';
import 'package:stepik_11/models/weather_forecast_daily.dart';
import 'package:stepik_11/screens/city_screen.dart';
import 'package:stepik_11/widgets/bottom_list_view.dart';
import 'package:stepik_11/widgets/city_view.dart';
import 'package:stepik_11/widgets/detail_view.dart';
import 'package:stepik_11/widgets/temp_view.dart';
import 'package:flutter/material.dart';

class WeatherForecastScreen extends StatefulWidget {
  final WeatherForecast? locationWeather;

  const WeatherForecastScreen({super.key, this.locationWeather});

  @override
  State<WeatherForecastScreen> createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  late Future<WeatherForecast> _forecast;

  /// Null means use the current location; otherwise use the selected city.
  String? _cityName;

  @override
  void initState() {
    super.initState();
    final initial = widget.locationWeather;
    _forecast = initial != null ? Future.value(initial) : _load();
  }

  Future<WeatherForecast> _load() {
    return WeatherApi().fetchWeatherForecast(
      city: _cityName,
      isCity: _cityName != null,
    );
  }

  void _reload() {
    setState(() {
      _forecast = _load();
    });
  }

  void _useMyLocation() {
    _cityName = null;
    _reload();
  }

  Future<void> _chooseCity() async {
    final city = await Navigator.push<String>(
      context,
      MaterialPageRoute<String>(builder: (_) => const CityScreen()),
    );
    if (!mounted || city == null || city.isEmpty) return;
    _cityName = city;
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.4),
        ),
        leading: IconButton(
          tooltip: 'Use my location',
          icon: const Icon(Icons.my_location),
          onPressed: _useMyLocation,
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Search for a city',
            icon: const Icon(Icons.search_rounded),
            onPressed: _chooseCity,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<WeatherForecast>(
        future: _forecast,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingState();
          }

          if (snapshot.hasError) {
            return _LoadError(
              message: snapshot.error.toString().replaceFirst(
                'Exception: ',
                '',
              ),
              onRetry: _reload,
            );
          }

          final data = snapshot.data;
          if (data == null || data.list == null || data.list.isEmpty) {
            return _LoadError(
              message: 'There is no forecast data available for this city.',
              onRetry: _reload,
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your forecast',
                      style: TextStyle(
                        color: Color(0xFF14213D),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Live conditions and the week ahead',
                      style: TextStyle(color: Color(0xFF78869B), fontSize: 14),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF142A52), Color(0xFF3478F6)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3478F6).withValues(alpha: 0.2),
                        blurRadius: 28,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -90,
                        right: -70,
                        child: _GlowOrb(size: 220),
                      ),
                      Positioned(
                        bottom: -120,
                        right: 70,
                        child: _GlowOrb(size: 200),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CityView(snapshot: snapshot),
                          const SizedBox(height: 28),
                          TempView(snapshot: snapshot),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              DetailView(snapshot: snapshot),
              const SizedBox(height: 28),
              BottomListView(snapshot: snapshot),
            ],
          );
        },
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 56, color: Color(0xFF64748B)),
            const SizedBox(height: 16),
            Text(
              'Could not load the weather',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF14213D),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF78869B)),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Getting your forecast…',
            style: TextStyle(color: Color(0xFF78869B)),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.07),
      ),
    );
  }
}
