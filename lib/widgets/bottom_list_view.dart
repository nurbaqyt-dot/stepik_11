import 'package:flutter/material.dart';
import 'package:stepik_11/models/weather_forecast_daily.dart';
import 'package:stepik_11/widgets/forecast_card.dart';

class BottomListView extends StatelessWidget {
  final AsyncSnapshot<WeatherForecast> snapshot;

  const BottomListView({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'NEXT 5 DAYS',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF78869B),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const Text(
                'DAILY',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9AA6B8),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 168,
          padding: const EdgeInsets.only(top: 16),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemCount: snapshot.data!.list.length < 5
                ? snapshot.data!.list.length
                : 5,
            itemBuilder: (context, index) => SizedBox(
              width: 112,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE9EEF5)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x080F172A),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: forecastCard(snapshot, index),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
