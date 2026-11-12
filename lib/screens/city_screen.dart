import 'package:flutter/material.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  String cityName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose a city',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.location_city_rounded,
                color: Color(0xFF3478F6),
                size: 40,
              ),
              const SizedBox(height: 20),
              const Text(
                'Where to next?',
                style: TextStyle(
                  color: Color(0xFF14213D),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.7,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Search for a city to see the local weather forecast.',
                style: TextStyle(
                  color: Color(0xFF78869B),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              TextField(
                cursorColor: const Color(0xFF3478F6),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.search,
                style: const TextStyle(
                  color: Color(0xFF14213D),
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter city name',
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Color(0xFF78869B),
                  ),
                  suffixIcon: Icon(
                    Icons.place_outlined,
                    color: Color(0xFF3478F6),
                  ),
                ),
                onChanged: (value) {
                  cityName = value;
                },
                onSubmitted: (_) => _submitCity(),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _submitCity,
                  icon: const Icon(Icons.wb_sunny_outlined),
                  label: const Text('Show weather'),
                ),
              ),
              const SizedBox(height: 14),
              const Center(
                child: Text(
                  'Try a city name like London or Almaty',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9AA6B8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitCity() {
    final city = cityName.trim();
    if (city.isNotEmpty) Navigator.pop(context, city);
  }
}
