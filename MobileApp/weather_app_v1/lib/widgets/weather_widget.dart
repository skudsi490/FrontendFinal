import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/weather_utils.dart';

class WeatherWidget extends StatelessWidget {
  final String city;
  final String temperature;
  final String weatherDescription;
  final double feelsLike;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final int windDegree;
  final int condition;
  final DateTime localTime;
  final bool isCelsius;

  const WeatherWidget({
    super.key,
    required this.city,
    required this.temperature,
    required this.weatherDescription,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.windDegree,
    required this.condition,
    required this.localTime,
    required this.isCelsius,
  });

  @override
  Widget build(BuildContext context) {
    String iconPath = WeatherUtils.getWeatherIcon(condition, localTime);
    String feelsLikeUnit = isCelsius ? '°C' : '°F';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
          temperature,
          style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          weatherDescription,
          style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/vectors/feels-like.svg', height: 24, width: 24),
            const SizedBox(width: 10),
            Text(
              'Feels like: $feelsLike$feelsLikeUnit',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
          mainAxisAlignment: MainAxisAlignment.center,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/vectors/wind.svg', height: 24, width: 24),
            const SizedBox(width: 10),
            Text(
              'Wind: $windSpeed m/s at $windDegree°',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
