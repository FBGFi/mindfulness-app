import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TODO get from global state and extend values to include more details
  final Map<String, String> _mindSets = {
    "11:00": "Sad",
    "12:00": "Angry",
    "13:00": "Joyful",
  };

  void _onAddNew() {
    setState(() {
      String now = DateFormat("HH:mm:ss").format(DateTime.now());
      _mindSets[now] = "New feeling";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text(DateFormat("EEE, d MMMM yyyy").format(DateTime.now()))),
      body: ListView(
          children: _mindSets.entries
              .map((entry) => Center(
                  child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.amber.withAlpha(200),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text(entry.key), Text(entry.value)],
                          )))))
              .toList()),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddNew,
        tooltip: "Add new",
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }
}
