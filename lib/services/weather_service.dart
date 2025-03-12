import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = "d2f8ad0b8e9d7d2177d5f28e686ddbb4";
  static const String _baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  static Future<Map<String, dynamic>> getWeather(String lat, String lon) async {
    final response = await http.get(
      Uri.parse("$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=nl"),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {"error": "Weer niet gevonden"};
    }
  }
}
