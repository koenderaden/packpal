import 'package:flutter/material.dart';
import 'weer_page.dart';
import 'inpaklijst_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _destinationController = TextEditingController();
  String selectedTransport = "Vliegtuig";
  DateTime selectedDate = DateTime.now();
  List<String> _suggestions = [];
  List<String> _allDestinations = [
    "Amsterdam",
    "Berlijn",
    "Parijs",
    "Londen",
    "New York",
    "Tokyo",
    "Barcelona",
    "Rome",
    "Kuala Lumpur",
    "Sydney",
  ];

  void _updateSuggestions(String input) async {
    if (input.isNotEmpty) {
      // Hier kun je de logica voor het ophalen van suggesties implementeren
      // Bijvoorbeeld, je kunt de suggesties filteren uit _allDestinations
      setState(() {
        _suggestions = _allDestinations
            .where((destination) => destination.toLowerCase().startsWith(input.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        _suggestions.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PackPal Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding rondom de hele body
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                labelText: 'Bestemming',
                border: OutlineInputBorder(), // Mooie rand om het tekstveld
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: _updateSuggestions,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5), // Ruimte tussen kaarten
                    child: ListTile(
                      title: Text(_suggestions[index]),
                      onTap: () {
                        _destinationController.text = _suggestions[index];
                        _suggestions.clear(); // Clear suggestions after selection
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigeren naar de WeerPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeerPage(
                      bestemming: _destinationController.text,
                      datum: selectedDate,
                    ),
                  ),
                );
              },
              child: Text('Bekijk Weer'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Grotere knoppen
                textStyle: TextStyle(fontSize: 18), // Grotere tekst
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigeren naar de PaklijstPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaklijstPage(bestemming: _destinationController.text),
                  ),
                );
              },
              child: Text('Bekijk Paklijst'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Grotere knoppen
                textStyle: TextStyle(fontSize: 18), // Grotere tekst
              ),
            ),
          ],
        ),
      ),
    );
  }
}
