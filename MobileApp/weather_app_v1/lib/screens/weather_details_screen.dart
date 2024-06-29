import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../utils/weather_utils.dart';

class WeatherDetailsScreen extends StatelessWidget {
  final String city;
  final double temperature;
  final String description;
  final double feelsLike;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final int windDegree;
  final int condition;
  final DateTime localTime;
  final DateTime? sunrise;
  final DateTime? sunset;
  final int? visibility;
  final double? windGusts;
  final String? airQuality;
  final bool isCelsius;

  const WeatherDetailsScreen({
    super.key,
    required this.city,
    required this.temperature,
    required this.description,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.windDegree,
    required this.condition,
    required this.localTime,
    this.sunrise,
    this.sunset,
    this.visibility,
    this.windGusts,
    this.airQuality,
    required this.isCelsius,
  });

  @override
  Widget build(BuildContext context) {
    String iconPath = WeatherUtils.getWeatherIcon(condition, localTime);
    String sunriseTime = sunrise != null ? DateFormat('h:mm a').format(sunrise!) : 'N/A';
    String sunsetTime = sunset != null ? DateFormat('h:mm a').format(sunset!) : 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Details'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/welcome.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              city,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            SvgPicture.asset(
              iconPath,
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 10),
            Text(
              '$temperature${isCelsius ? '°C' : '°F'}',
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset('assets/vectors/feels-like.svg', height: 24, width: 24),
                const SizedBox(width: 10),
                Text(
                  'Feels like: $feelsLike${isCelsius ? '°C' : '°F'}',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset('assets/vectors/pressure.svg', height: 24, width: 24),
                const SizedBox(width: 10),
                Text(
                  'Pressure: $pressure hPa',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset('assets/vectors/humidity.svg', height: 24, width: 24),
                const SizedBox(width: 10),
                Text(
                  'Humidity: $humidity%',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset('assets/vectors/wind.svg', height: 24, width: 24),
                const SizedBox(width: 10),
                Text(
                  'Wind: $windSpeed m/s at $windDegree°',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            if (visibility != null) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/vectors/visibility.svg', height: 24, width: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Visibility: ${visibility! / 1000} km',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset('assets/vectors/sunrise.svg', height: 24, width: 24),
                const SizedBox(width: 10),
                Text(
                  'Sunrise: $sunriseTime',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset('assets/vectors/sunset.svg', height: 24, width: 24),
                const SizedBox(width: 10),
                Text(
                  'Sunset: $sunsetTime',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            if (windGusts != null) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/vectors/wind-gusts.svg', height: 24, width: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Wind Gusts: $windGusts km/h',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ],
            if (airQuality != null) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/vectors/air-quality.svg', height: 24, width: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Air Quality: $airQuality',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
