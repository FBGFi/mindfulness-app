import 'package:flutter/material.dart';

void main() {
  runApp(const MindfulnessApp());
}

class MindfulnessApp extends StatefulWidget {
  const MindfulnessApp({super.key});

  @override
  State<MindfulnessApp> createState() => _MindfulnessAppState();
}

class _MindfulnessAppState extends State<MindfulnessApp> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = [
    Text(
      "Home",
      style: optionStyle,
    ),
    Text(
      "Calendar",
      style: optionStyle,
    ),
    Text(
      "Analytics",
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindfulness App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month), label: "Calendar"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.analytics), label: "Analytics"),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped,
            ),
          )),
    );
  }
}
