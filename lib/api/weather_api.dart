import 'dart:convert';
import 'dart:developer';

import 'package:stepik_11/utilities/location.dart';
import 'package:http/http.dart' as http;
import 'package:stepik_11/models/weather_forecast_daily.dart';
import 'package:stepik_11/utilities/constants.dart';

class WeatherApi {
  Future<WeatherForecast> fetchWeatherForecast({
    String? city,
    bool isCity = false,
  }) async {
    final Map<String, String> parameters = {
      'appid': Constants.weatherAppId,
      'units': 'metric',
      'lang': 'en',
    };

    if (isCity) {
      parameters['q'] = city ?? '';
    } else {
      try {
        final location = Location();
        await location.getCurrentLocation();
        parameters['lat'] = location.latitude.toString();
        parameters['lon'] = location.longitude.toString();
      } catch (e) {
        log('Location unavailable: $e. Using ${Constants.defaultCity}');
        parameters['q'] = Constants.defaultCity;
      }
    }

    final uri = Uri.https(
      Constants.weatherBaseUrlDomain,
      Constants.weatherForecastPath,
      parameters,
    );
    log('request: $uri');

    final response = await http.get(uri);
    log('status: ${response.statusCode}, body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return WeatherForecast.fromJson(_toDaily(data));
    } else if (response.statusCode == 404) {
      throw Exception('City not found. Please enter a valid city name.');
    } else if (response.statusCode == 401) {
      throw Exception('Invalid API key (401).\nCheck weatherAppId');
    } else {
      throw Exception(
        'Failed to load the weather forecast '
        '(${response.statusCode})',
      );
    }
  }

  Map<String, dynamic> _toDaily(Map<String, dynamic> data) {
    final city = Map<String, dynamic>.from(data['city'] as Map);
    final int tz = (city['timezone'] as num?)?.toInt() ?? 0;
    final int sunrise = (city['sunrise'] as num?)?.toInt() ?? 0;
    final int sunset = (city['sunset'] as num?)?.toInt() ?? 0;
    final Map<String, List<Map<String, dynamic>>> byDay = {};
    for (final item in data['list'] as List) {
      final m = Map<String, dynamic>.from(item as Map);
      final local = _localTime(m, tz);
      final key = '${local.year}-${local.month}-${local.day}';
      byDay.putIfAbsent(key, () => []).add(m);
    }

    final List<Map<String, dynamic>> days = [];

    for (final items in byDay.values) {
      final noon = _closest(items, 12, tz);

      double main(Map<String, dynamic> m, String f) =>
          ((m['main'] as Map)[f] as num).toDouble();

      final temps = items.map((m) => main(m, 'temp_min')).toList();
      final tempsMax = items.map((m) => main(m, 'temp_max')).toList();

      final morn = _closest(items, 6, tz);
      final eve = _closest(items, 18, tz);
      final night = _closest(items, 3, tz);

      final pressure =
          items.map((m) => main(m, 'pressure')).reduce((a, b) => a + b) /
          items.length;
      final humidity =
          items.map((m) => main(m, 'humidity')).reduce((a, b) => a + b) /
          items.length;
      final speed =
          items
              .map((m) => ((m['wind'] as Map)['speed'] as num).toDouble())
              .reduce((a, b) => a + b) /
          items.length;

      double rain = 0;
      for (final m in items) {
        final r = m['rain'];
        if (r is Map && r['3h'] != null) {
          rain += (r['3h'] as num).toDouble();
        }
      }
      final weather = (noon['weather'] as List).map((w) {
        final wm = Map<String, dynamic>.from(w as Map);
        wm['icon'] = (wm['icon'] as String).replaceAll('n', 'd');
        return wm;
      }).toList();

      days.add({
        'dt': noon['dt'],
        'sunrise': sunrise,
        'sunset': sunset,
        'temp': {
          'day': main(noon, 'temp'),
          'min': temps.reduce((a, b) => a < b ? a : b),
          'max': tempsMax.reduce((a, b) => a > b ? a : b),
          'night': main(night, 'temp'),
          'eve': main(eve, 'temp'),
          'morn': main(morn, 'temp'),
        },
        'feels_like': {
          'day': main(noon, 'feels_like'),
          'night': main(night, 'feels_like'),
          'eve': main(eve, 'feels_like'),
          'morn': main(morn, 'feels_like'),
        },
        'pressure': pressure.round(),
        'humidity': humidity.round(),
        'weather': weather,
        'speed': speed,
        'deg': (noon['wind'] as Map)['deg'],
        'clouds': (noon['clouds'] as Map)['all'],
        'rain': rain > 0 ? rain : null,
      });
    }

    return {
      'city': city,
      'cod': data['cod'],
      'message': data['message'],
      'cnt': days.length,
      'list': days,
    };
  }

  DateTime _localTime(Map<String, dynamic> m, int tz) =>
      DateTime.fromMillisecondsSinceEpoch(
        ((m['dt'] as num).toInt() + tz) * 1000,
        isUtc: true,
      );

  Map<String, dynamic> _closest(
    List<Map<String, dynamic>> items,
    int hour,
    int tz,
  ) {
    var best = items.first;
    var bestDiff = 100;
    for (final m in items) {
      final diff = (_localTime(m, tz).hour - hour).abs();
      if (diff < bestDiff) {
        bestDiff = diff;
        best = m;
      }
    }
    return best;
  }
}
