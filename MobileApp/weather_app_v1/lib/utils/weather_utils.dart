import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherUtils {
  static String getWeatherIcon(int condition, DateTime localTime) {
    bool isNight = _isNightTime(localTime);

    if (condition >= 200 && condition <= 232) {
      if (condition == 202 || condition == 211 || condition == 212 || condition == 221 || condition == 232) {
        return 'assets/svgs/thunder.svg';
      } else if (condition == 200 || condition == 201 || condition == 230 || condition == 231) {
        return isNight ? 'assets/svgs/thunderMoonRain.svg' : 'assets/svgs/thunderWind.svg';
      } else {
        return 'assets/svgs/thunderWind.svg';
      }
    } else if (condition >= 300 && condition <= 321) {
      if (condition >= 300 && condition <= 302) {
        return 'assets/svgs/cloudRainLow.svg';
      } else if (condition >= 310 && condition <= 312) {
        return 'assets/svgs/cloudRainMiddle.svg';
      } else {
        return 'assets/svgs/cloudRainStrong.svg';
      }
    } else if (condition >= 500 && condition <= 531) {
      if (condition == 511) {
        return 'assets/svgs/cloudySnow.svg'; // Freezing rain
      } else if (condition == 520 || condition == 521 || condition == 522 || condition == 531) {
        return 'assets/svgs/cloudRainStrong.svg'; // Heavy shower rain
      } else if (condition >= 500 && condition <= 504) {
        return 'assets/svgs/cloudyRain.svg'; // Rain
      } else {
        return 'assets/svgs/cloudRainMiddle.svg';
      }
    } else if (condition >= 600 && condition <= 622) {
      if (condition == 600 || condition == 620) {
        return 'assets/svgs/cloudySnow.svg';
      } else if (condition == 601 || condition == 621) {
        return isNight ? 'assets/svgs/moonSnow.svg' : 'assets/svgs/sunSnow.svg';
      } else if (condition == 602 || condition == 622) {
        return 'assets/svgs/cloudySnow.svg';
      } else {
        return isNight ? 'assets/svgs/moonSnow.svg' : 'assets/svgs/sunSnow.svg';
      }
    } else if (condition >= 701 && condition <= 781) {
      if (condition == 711 || condition == 721 || condition == 741 || condition == 751 || condition == 761 || condition == 762) {
        return 'assets/svgs/cloudWind.svg';
      } else if (condition == 731 || condition == 771 || condition == 781) {
        return 'assets/svgs/thunderWind.svg';
      } else {
        return 'assets/svgs/cloudy.svg';
      }
    } else if (condition == 800) {
      return isNight ? 'assets/svgs/moon.svg' : 'assets/svgs/sun.svg'; // Clear sky
    } else if (condition == 801) {
      return isNight ? 'assets/svgs/moonCloudy.svg' : 'assets/svgs/sunCloudy.svg'; // Few clouds
    } else if (condition == 802) {
      return 'assets/svgs/cloudy.svg'; // Scattered clouds
    } else if (condition == 803 || condition == 804) {
      return 'assets/svgs/cloudy.svg'; // Broken clouds
    } else {
      return 'assets/svgs/cloudy.svg'; // Default to scattered clouds
    }
  }

  static bool _isNightTime(DateTime localTime) {
    final hour = int.parse(DateFormat('H').format(localTime));
    debugPrint('Local time: ${localTime.toIso8601String()}');
    debugPrint('Local hour: $hour');
    return hour < 6 || hour >= 18;
  }
}
