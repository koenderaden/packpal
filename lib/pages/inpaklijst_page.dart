import 'package:flutter/material.dart';

class PaklijstPage extends StatelessWidget {
  final String bestemming;

  PaklijstPage({required this.bestemming});

  final List<String> basisItems = ["Paspoort", "Telefoon", "Lader", "Kleding"];
  final List<String> warmeKleding = ["Winterjas", "Muts", "Handschoenen"];
  final List<String> zomerkleding = ["Zonnebrand", "Zonnebril", "Slippers"];

  @override
  Widget build(BuildContext context) {
    List<String> paklijst = [...basisItems, ...zomerkleding]; // Later uitbreiden met weer-data

    return Scaffold(
      appBar: AppBar(title: Text("Paklijst voor $bestemming")),
      body: ListView.builder(
        itemCount: paklijst.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.check_box_outline_blank),
            title: Text(paklijst[index]),
          );
        },
      ),
    );
  }
}
