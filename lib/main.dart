import 'package:flutter/material.dart';
import 'package:mindfulness_app/pages/analytics/analytics.dart';
import 'package:mindfulness_app/pages/calendar/calendar.dart';
import 'package:mindfulness_app/pages/home/home.dart';

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

  static const List<Widget> _pages = [
    HomePage(),
    CalendarPage(),
    AnalyticsPage(),
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: const TextTheme(
            bodySmall: TextStyle(fontSize: 15.0),
            bodyMedium: TextStyle(fontSize: 18.0)),
        useMaterial3: true,
      ),
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
            body: Center(
              child: _pages.elementAt(_selectedIndex),
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
              selectedItemColor: Colors.blue,
              onTap: _onItemTapped,
            ),
          )),
    );
  }
}
