import 'package:flutter/material.dart';
import '../services/packing_service.dart';

class PaklijstPage extends StatefulWidget {
  final String bestemming;
  final double temperature;
  final String weatherDescription;
  final String iconUrl;

  PaklijstPage({
    required this.bestemming,
    required this.temperature,
    required this.weatherDescription,
    required this.iconUrl,
  });

  @override
  _PaklijstPageState createState() => _PaklijstPageState();
}

class _PaklijstPageState extends State<PaklijstPage> {
  List<String> essentialItems = [];
  List<bool> essentialItemsChecked = [];
  List<String> additionalItems = [];
  List<bool> additionalItemsChecked = [];
  final TextEditingController _itemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    essentialItems = PackingService.generatePackingList(widget.temperature);
    essentialItemsChecked = List<bool>.filled(essentialItems.length, false);
  }

  void _addItem() {
    if (_itemController.text.isNotEmpty) {
      setState(() {
        additionalItems.add(_itemController.text);
        additionalItemsChecked.add(false);
        _itemController.clear();
      });
    }
  }

  void _toggleEssentialItem(int index) {
    setState(() {
      essentialItemsChecked[index] = !essentialItemsChecked[index];
    });
  }

  void _toggleAdditionalItem(int index) {
    setState(() {
      additionalItemsChecked[index] = !additionalItemsChecked[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (widget.temperature >= 25) {
      backgroundColor = Colors.orange.shade200; // Warm color
    } else if (widget.temperature >= 15) {
      backgroundColor = Colors.lightBlue.shade100; // Neutral color
    } else {
      backgroundColor = Colors.blue.shade200; // Cold color
    }

    int roundedTemperature = widget.temperature.round();

    return Scaffold(
      appBar: AppBar(
        title: Text("Packing List for ${widget.bestemming}"),
        backgroundColor: backgroundColor,
      ),
      body: Container(
        color: backgroundColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Weather: ${roundedTemperature}°C, ${widget.weatherDescription}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (widget.iconUrl.isNotEmpty)
                    Image.network(
                      widget.iconUrl,
                      width: 40,
                      height: 40,
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Essential Items",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...List.generate(essentialItems.length, (index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                        leading: Icon(
                          essentialItemsChecked[index]
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: essentialItemsChecked[index] ? Colors.green : null,
                        ),
                        title: Text(essentialItems[index]),
                        onTap: () => _toggleEssentialItem(index),
                      ),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Additional Items",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...List.generate(additionalItems.length, (index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                        leading: Icon(
                          additionalItemsChecked[index]
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: additionalItemsChecked[index] ? Colors.green : null,
                        ),
                        title: Text(additionalItems[index]),
                        onTap: () => _toggleAdditionalItem(index),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _itemController,
                      decoration: InputDecoration(
                        labelText: 'Add item',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addItem,
                    child: Text('Add'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
