import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'weer_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _destinationController = TextEditingController();
  List<Map<String, String>> _suggestions = [];
  String? selectedLat;
  String? selectedLng;
  bool showButtons = false;

  void _fetchCitySuggestions(String input) async {
    final response = await http.get(
      Uri.parse("http://api.geonames.org/searchJSON?q=$input&featureClass=P&featureCode=PPL&featureCode=PPLA&featureCode=PPLC&maxRows=10&username=koenderaden"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _suggestions = (data["geonames"] as List)
            .where((city) => city["name"].toString().toLowerCase().startsWith(input.toLowerCase()))
            .map((city) {
              String cityName = city["name"].toString();
              if (city.containsKey("alternateNames")) {
                for (var altName in city["alternateNames"]) {
                  if (altName["lang"] == "nl") {
                    cityName = altName["name"];
                    break;
                  }
                }
              }
              return {
                "name": cityName,
                "lat": city["lat"].toString(),
                "lng": city["lng"].toString(),
              };
            })
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("PackPal - Inpakassistent"),
        backgroundColor: Colors.blue,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Afbeelding
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1522199710521-72d69614c702?q=80&w=3231&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Introductie
                      Text(
                        "Welkom bij PackPal! 🎒",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "PackPal helpt je bij het plannen van je reis. Voer je bestemming in en ontdek het weer en een handige paklijst!",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 20),

                      // Zoekbalk
                      TextField(
                        controller: _destinationController,
                        decoration: InputDecoration(
                          hintText: "Zoek een stad of dorp...",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.green.shade50,
                          prefixIcon: Icon(Icons.search, color: Colors.blue),
                        ),
                        onChanged: (input) {
                          _fetchCitySuggestions(input);
                          setState(() {
                            showButtons = false;
                          });
                        },
                      ),
                      SizedBox(height: 10),

                      // Suggestielijst
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: _suggestions.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _suggestions.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                        title: Text(
                                          _suggestions[index]["name"]!,
                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                        ),
                                        trailing: Icon(Icons.location_on, color: Colors.redAccent),
                                        onTap: () {
                                          setState(() {
                                            _destinationController.text = _suggestions[index]["name"]!;
                                            selectedLat = _suggestions[index]["lat"];
                                            selectedLng = _suggestions[index]["lng"];
                                            _suggestions.clear();
                                            showButtons = true;
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),

            // Knoppen blijven ALTIJD zichtbaar
            if (showButtons) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_destinationController.text.isNotEmpty && selectedLat != null && selectedLng != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeerPage(
                                bestemming: _destinationController.text,
                                latitude: selectedLat!,
                                longitude: selectedLng!,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Bekijk Weer", style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_destinationController.text.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Paklijst functie nog niet geïmplementeerd!")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Genereer Inpaklijst", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}
