import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/weather_service.dart';
import 'home_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool _isCelsius = true;
  String _cityWeather = "Enter a city to get weather information";
  final TextEditingController _cityController = TextEditingController();
  String _lastSelectedCity = '';
  bool _isSelectedCity = false;
  int _tapCount = 0;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isCelsius = prefs.getBool('isCelsius') ?? true;
      _cityController.text = prefs.getString('selectedCity') ?? '';
      _lastSelectedCity = _cityController.text;
      _isSelectedCity = _lastSelectedCity.isNotEmpty;
    });
  }

  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isCelsius', _isCelsius);
    prefs.setString('selectedCity', _cityController.text);
  }

  Future<void> _fetchWeather(String city) async {
    try {
      var weather = await WeatherService().getWeatherByCity(city, _isCelsius ? 'metric' : 'imperial');
      setState(() {
        _cityWeather = '${weather.cityName}: ${weather.temperature}°${_isCelsius ? 'C' : 'F'}, ${weather.description}';
        _isSelectedCity = true;
      });
    } catch (e) {
      setState(() {
        _cityWeather = "Unable to fetch weather data";
        _isSelectedCity = false;
      });
    }
  }

  void _redirectToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _handleCitySubmission(String value) {
    if (value.isNotEmpty) {
      _fetchWeather(value);
      _savePreferences();
      setState(() {
        if (value == _lastSelectedCity) {
          _tapCount++;
          if (_tapCount == 2) {
            _redirectToHomeScreen();
          }
        } else {
          _lastSelectedCity = value;
          _tapCount = 1;
        }
      });
    } else {
      setState(() {
        _cityWeather = "Please enter a valid city name";
        _isSelectedCity = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchListTile(
              title: const Text('Use Celsius'),
              value: _isCelsius,
              onChanged: (bool value) {
                setState(() {
                  _isCelsius = value;
                  _savePreferences();
                });
              },
            ),
            GestureDetector(
              onTap: () {
                _handleCitySubmission(_cityController.text);
              },
              child: TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'Enter city name',
                  filled: true,
                  fillColor: _isSelectedCity ? Colors.blue.withOpacity(0.2) : null,
                ),
                onSubmitted: _handleCitySubmission,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                _handleCitySubmission(_cityController.text);
              },
              onDoubleTap: () {
                if (_cityController.text == _lastSelectedCity) {
                  _redirectToHomeScreen();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: _isSelectedCity ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                child: Text(
                  _cityWeather,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
