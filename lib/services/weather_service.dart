import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = "d2f8ad0b8e9d7d2177d5f28e686ddbb4"; // Jouw API-sleutel

  static Future<Map<String, dynamic>> getWeather(String latitude, String longitude) async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric"));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  static Future<Map<String, dynamic>> getWeatherForCity(String city) async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric"));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load weather data");
    }
  }
}
