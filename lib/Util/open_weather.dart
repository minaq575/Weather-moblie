import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../data_classes/weather_data/weather_data.dart';

class OpenWeather {
  static Future<Position> _determinePosition(LocationAccuracy lowest) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location service are disabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission are denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Location permission are permanenty denied, we cannot request permissions.");
    }
    return await Geolocator.getCurrentPosition();
  }

  static Future<WeatherData> fetchBycurrentPosition() async {
    await dotenv.load(fileName: 'lib/.env');
    Position position = await _determinePosition(LocationAccuracy.lowest);
    String latitude = position.latitude.toStringAsFixed(3);
    String longtitude = position.longitude.toStringAsFixed(3);
    String url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longtitude&appid=${dotenv.env['API_KEY']}';
    return await _fetch(url);
  }

  static Future<WeatherData> _fetch(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load weather data');
    }
    return WeatherData.fromJson(response.body);
  }

  static Future<WeatherData> fetchByCityName({required cityName}) async {
    String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=${dotenv.env['API_KEY']}&units = metric';
    try {
      return await _fetch(url);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
