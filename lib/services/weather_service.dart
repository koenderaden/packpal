import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = "d2f8ad0b8e9d7d2177d5f28e686ddbb4";
  static const String _baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  static Future<String> getWeather(String locatie) async {
    final response = await http.get(Uri.parse("$_baseUrl?q=$locatie&appid=$_apiKey&units=metric&lang=nl"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return "Temperatuur: ${data["main"]["temp"]}°C\nWeer: ${data["weather"][0]["description"]}";
    } else {
      return "Kan weer niet ophalen";
    }
  }
}
