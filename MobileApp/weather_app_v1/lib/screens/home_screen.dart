import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'weather_details_screen.dart' as details;
import 'settings_screen.dart';
import '../services/weather_service.dart';
import '../widgets/weather_widget.dart' as widget;
import '../models/weather.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String _city = "Unknown";
  String _temperature = "Loading...";
  String _weatherDescription = "Loading...";
  double _feelsLike = 0.0;
  int _pressure = 0;
  int _humidity = 0;
  double _windSpeed = 0.0;
  int _windDegree = 0;
  int _condition = 0;
  DateTime _localTime = DateTime.now();
  bool _isLoading = true;
  bool _isCelsius = true;
  String _selectedCity = "";
  Weather? _weather; // Store the weather object

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _checkLocationPermission();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isCelsius = prefs.getBool('isCelsius') ?? true;
      _selectedCity = prefs.getString('selectedCity') ?? '';
    });
    _getWeather();
  }

  Future<void> _checkLocationPermission() async {
    PermissionStatus status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      status = await Permission.locationWhenInUse.request();
    }

    if (status.isGranted) {
      _getWeather();
    } else {
      setState(() {
        _city = "Permission Denied";
        _temperature = "N/A";
        _weatherDescription = "Location access denied";
        _isLoading = false;
      });
    }
  }

  Future<void> _getWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Weather weather;
      if (_selectedCity.isNotEmpty) {
        weather = await WeatherService().getWeatherByCity(_selectedCity, _isCelsius ? 'metric' : 'imperial');
      } else {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        weather = await WeatherService().getWeather(position.latitude, position.longitude, _isCelsius ? 'metric' : 'imperial');
      }

      setState(() {
        _weather = weather; // Assign the weather object
        _city = weather.cityName;
        _temperature = '${weather.temperature.toStringAsFixed(1)}${_isCelsius ? '°C' : '°F'}';
        _weatherDescription = weather.description;
        _feelsLike = weather.feelsLike;
        _pressure = weather.pressure;
        _humidity = weather.humidity;
        _windSpeed = weather.windSpeed;
        _windDegree = weather.windDegree;
        _condition = weather.condition;
        _localTime = weather.localTime;
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _city = "Error";
        _temperature = "N/A";
        _weatherDescription = "Unable to fetch weather data";
        _isLoading = false;
      });
    }
  }

  Future<void> _clearSelectedCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('selectedCity');
    setState(() {
      _selectedCity = '';
    });
    _getWeather();
  }

  void _navigateToWeatherDetails() {
    double temperatureValue;
    try {
      temperatureValue = double.parse(_temperature.split('°')[0]);
    } catch (e) {
      temperatureValue = 0.0; // Default value or handle accordingly
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => details.WeatherDetailsScreen(
          city: _city,
          temperature: temperatureValue,
          description: _weatherDescription,
          feelsLike: _feelsLike,
          pressure: _pressure,
          humidity: _humidity,
          windSpeed: _windSpeed,
          windDegree: _windDegree,
          condition: _condition,
          localTime: _localTime,
          sunrise: _weather?.sunrise,
          sunset: _weather?.sunset,
          visibility: _weather?.visibility,
          windGusts: _weather?.windGusts,
          airQuality: _weather?.airQuality?.toString(), // Convert to String for display
          isCelsius: _isCelsius,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getWeather,
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: _navigateToWeatherDetails,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/welcome.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 100, width: 100),
              widget.WeatherWidget(
                city: _city,
                temperature: _temperature,
                weatherDescription: _weatherDescription,
                feelsLike: _feelsLike,
                pressure: _pressure,
                humidity: _humidity,
                windSpeed: _windSpeed,
                windDegree: _windDegree,
                condition: _condition,
                localTime: _localTime,
                isCelsius: _isCelsius,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _clearSelectedCity,
                child: const Text("Use Current Location"),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                image: DecorationImage(
                  image: const AssetImage('assets/images/world2.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.deepPurpleAccent.withOpacity(0.6),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Weather Details'),
              onTap: _navigateToWeatherDetails,
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                ).then((_) {
                  _loadPreferences();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
