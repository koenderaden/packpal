import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/weather_service.dart';
import 'package:intl/intl.dart'; // For date formatting

class WeerPage extends StatefulWidget {
  final String bestemming;
  final String latitude;
  final String longitude;

  WeerPage({required this.bestemming, required this.latitude, required this.longitude});

  @override
  _WeerPageState createState() => _WeerPageState();
}

class _WeerPageState extends State<WeerPage> {
  String temperature = "Loading...";
  String feelsLikeTemperature = "";
  String weatherDescription = "Loading...";
  String windSpeed = "";
  String humidity = "";
  String iconUrl = "";
  String currentDate = DateFormat('EEEE d MMMM yyyy', 'en').format(DateTime.now()); // English date
  List<Map<String, String>> weekForecast = [];

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _fetchWeekForecast();
  }

  void _fetchWeather() async {
    Map<String, dynamic> weatherData = await WeatherService.getWeather(widget.latitude, widget.longitude);
    setState(() {
      if (weatherData.containsKey("error")) {
        temperature = "No data";
        weatherDescription = "Could not fetch weather";
      } else {
        double temp = double.parse(weatherData["main"]["temp"].toString());
        double feelsLikeTemp = double.parse(weatherData["main"]["feels_like"].toString());
        int roundedTemp = temp.round();
        int roundedFeelsLikeTemp = feelsLikeTemp.round();

        temperature = "$roundedTemp°C";
        feelsLikeTemperature = "Feels like: $roundedFeelsLikeTemp°C";
        weatherDescription = weatherData["weather"][0]["description"];
        windSpeed = "💨 Wind: ${weatherData["wind"]["speed"]} m/s";
        humidity = "💧 Humidity: ${weatherData["main"]["humidity"]}%";
        iconUrl = "https://openweathermap.org/img/wn/${weatherData["weather"][0]["icon"]}@2x.png";
      }
    });
  }

  void _fetchWeekForecast() async {
    String apiKey = "YOUR_OPENWEATHERMAP_API_KEY"; // Insert your API key here
    String url =
        "https://api.openweathermap.org/data/2.5/forecast?lat=${widget.latitude}&lon=${widget.longitude}&appid=$apiKey&units=metric&lang=en";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Map<String, String>> forecast = [];

      // Get the first forecast per day (every 24 hours in the JSON)
      for (int i = 0; i < jsonData["list"].length; i += 8) {
        var dayData = jsonData["list"][i];
        DateTime date = DateTime.fromMillisecondsSinceEpoch(dayData["dt"] * 1000);
        String dayName = DateFormat('EEEE', 'en').format(date); // Day in English
        int dayTemp = double.parse(dayData["main"]["temp"].toString()).round();
        String weatherDescription = dayData["weather"][0]["description"];
        String icon = dayData["weather"][0]["icon"];

        forecast.add({
          "day": dayName,
          "temp": "$dayTemp°C",
          "description": weatherDescription,
          "icon": icon,
        });

        if (forecast.length == 5) break; // Maximum 5 days forecast
      }

      setState(() {
        weekForecast = forecast;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather in ${widget.bestemming}"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              currentDate,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),

            // Weather card with info
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white.withOpacity(0.9),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Weather in ${widget.bestemming}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      temperature,
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      feelsLikeTemperature,
                      style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                    ),
                    SizedBox(height: 10),
                    if (iconUrl.isNotEmpty)
                      Image.network(
                        iconUrl,
                        width: 60,
                        height: 60,
                      ),
                    SizedBox(height: 10),
                    Text(
                      weatherDescription,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Divider(color: Colors.grey.shade300),
                    SizedBox(height: 10),
                    Text(windSpeed, style: TextStyle(fontSize: 16, color: Colors.black87)),
                    SizedBox(height: 5),
                    Text(humidity, style: TextStyle(fontSize: 16, color: Colors.black87)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Week forecast
            if (weekForecast.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: weekForecast.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.network(
                        "https://openweathermap.org/img/wn/${weekForecast[index]["icon"]}@2x.png",
                        width: 40,
                        height: 40,
                      ),
                      title: Text(
                        weekForecast[index]["day"]!,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      subtitle: Text(
                        "${weekForecast[index]["temp"]!} - ${weekForecast[index]["description"]!}",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    );
                  },
                ),
              ),

            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text("Back", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}