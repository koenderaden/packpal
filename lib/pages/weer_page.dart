import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import 'inpaklijst_page.dart';

class WeerPage extends StatefulWidget {
  final String bestemming;
  final DateTime datum;

  WeerPage({required this.bestemming, required this.datum});

  @override
  _WeerPageState createState() => _WeerPageState();
}

class _WeerPageState extends State<WeerPage> {
  String _weerInfo = "Laden...";

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() async {
    String weer = await WeatherService.getWeather(widget.bestemming);
    setState(() {
      _weerInfo = weer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weer in ${widget.bestemming}")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weerInfo, style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Ga naar Paklijst"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaklijstPage(bestemming: widget.bestemming),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
