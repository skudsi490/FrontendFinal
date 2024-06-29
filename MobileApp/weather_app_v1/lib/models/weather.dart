class Weather {
  final double temperature;
  final String description;
  final String cityName;
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
  final int? airQuality;
  final double? realFeel;

  Weather({
    required this.temperature,
    required this.description,
    required this.cityName,
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
    this.realFeel,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'],
      cityName: json['name'],
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      windDegree: json['wind']['deg'],
      condition: json['weather'][0]['id'],
      localTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: true).toLocal(),
      sunrise: json['sys']['sunrise'] != null ? DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000, isUtc: true).toLocal() : null,
      sunset: json['sys']['sunset'] != null ? DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000, isUtc: true).toLocal() : null,
      visibility: json['visibility'],
      windGusts: json['wind']['gust'] != null ? (json['wind']['gust'] as num).toDouble() : null,
      airQuality: null, // This will be set later
      realFeel: (json['main']['feels_like'] as num).toDouble(),
    );
  }

  Weather copyWith({int? airQuality}) {
    return Weather(
      temperature: temperature,
      description: description,
      cityName: cityName,
      feelsLike: feelsLike,
      pressure: pressure,
      humidity: humidity,
      windSpeed: windSpeed,
      windDegree: windDegree,
      condition: condition,
      localTime: localTime,
      sunrise: sunrise,
      sunset: sunset,
      visibility: visibility,
      windGusts: windGusts,
      airQuality: airQuality ?? this.airQuality,
      realFeel: realFeel,
    );
  }
}
