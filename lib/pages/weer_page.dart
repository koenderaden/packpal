import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/weather_service.dart';

class WeerPage extends StatefulWidget {
  final String bestemming;
  final String latitude;
  final String longitude;

  WeerPage({required this.bestemming, required this.latitude, required this.longitude});

  @override
  _WeerPageState createState() => _WeerPageState();
}

class _WeerPageState extends State<WeerPage> {
  String temperatuur = "Laden...";
  String gevoelstemperatuur = "";
  String weerBeschrijving = "Laden...";
  String windSnelheid = "";
  String luchtvochtigheid = "";
  String icoonUrl = "";

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() async {
    Map<String, dynamic> weerData = await WeatherService.getWeather(widget.latitude, widget.longitude);
    setState(() {
      if (weerData.containsKey("error")) {
        temperatuur = "Geen gegevens";
        weerBeschrijving = "Kon het weer niet ophalen";
      } else {
        // Temperatuur afronden
        double temp = double.parse(weerData["main"]["temp"].toString());
        double gevoelTemp = double.parse(weerData["main"]["feels_like"].toString());
        int afgerondeTemp = temp.round();
        int afgerondeGevoelTemp = gevoelTemp.round();

        temperatuur = "$afgerondeTemp°C";
        gevoelstemperatuur = "Voelt als: $afgerondeGevoelTemp°C";
        weerBeschrijving = weerData["weather"][0]["description"];
        windSnelheid = "💨 Wind: ${weerData["wind"]["speed"]} m/s";
        luchtvochtigheid = "💧 Luchtvochtigheid: ${weerData["main"]["humidity"]}%";

        // Weericoon ophalen
        icoonUrl = "https://openweathermap.org/img/wn/${weerData["weather"][0]["icon"]}@2x.png";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weer in ${widget.bestemming}"),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Weerkaart met info
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
                      "Weer in ${widget.bestemming}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      temperatuur,
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      gevoelstemperatuur,
                      style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                    ),
                    SizedBox(height: 10),
                    if (icoonUrl.isNotEmpty)
                      Image.network(
                        icoonUrl,
                        width: 60,
                        height: 60,
                      ),
                    SizedBox(height: 10),
                    Text(
                      weerBeschrijving,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Divider(color: Colors.grey.shade300),
                    SizedBox(height: 10),
                    Text(
                      windSnelheid,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 5),
                    Text(
                      luchtvochtigheid,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),

            // Terugknop
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text("Terug", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}