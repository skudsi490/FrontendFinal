import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  final String _apiKey = 'ef603383fe613b550ab3299a63a86a5b';

  Future<Weather> getWeather(double lat, double lon, String units) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=$units'));

    if (response.statusCode == 200) {
      Weather weather = Weather.fromJson(jsonDecode(response.body));
      int airQuality = await getAirQuality(lat, lon);
      weather = weather.copyWith(airQuality: airQuality);
      return weather;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Weather> getWeatherByCity(String city, String units) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=$units'));

    if (response.statusCode == 200) {
      Weather weather = Weather.fromJson(jsonDecode(response.body));
      // Fetch the latitude and longitude from the response
      double lat = jsonDecode(response.body)['coord']['lat'];
      double lon = jsonDecode(response.body)['coord']['lon'];
      int airQuality = await getAirQuality(lat, lon);
      weather = weather.copyWith(airQuality: airQuality);
      return weather;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<int> getAirQuality(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$_apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['list'][0]['main']['aqi'];
    } else {
      throw Exception('Failed to load air quality data');
    }
  }
}
