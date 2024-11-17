import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mindfulness_app/models/mind_set_object.dart';
import 'package:mindfulness_app/pages/analytics/analytics.dart';
import 'package:mindfulness_app/pages/calendar/calendar.dart';
import 'package:mindfulness_app/pages/home/home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mindfulness_app/utils/constants.dart';

void applyTestData(Box<List<MindSetObject>> box) {
  final today = DateTime.now();
  final todayMidnight =
      DateTime(today.year, today.month, today.day).millisecondsSinceEpoch;
  final List<MindSetObject> mindSets = [];
  final categoryMap = MIND_SET_VALUES.keys.toList().asMap();
  final feelingMap = MIND_SET_VALUES.values
      .map((entry) => entry.keys.toList().asMap())
      .toList()
      .asMap();

  for (var i = 7; i >= 0; i--) {
    for (var j = 0; j < 4; j++) {
      final randomCategoryIndex = Random().nextInt(categoryMap.keys.length);
      final categoryName = categoryMap[randomCategoryIndex]!;
      final randomFeelingIndex = Random().nextInt(feelingMap.keys.length);
      final feelingName = feelingMap[randomCategoryIndex]![randomFeelingIndex]!;
      mindSets.add(MindSetObject(
          date: todayMidnight -
              (i * 60 * 60 * 24 * 1000) +
              ((1 + j) * 4 * 60 * 60 * 1000),
          category: categoryName,
          feeling: feelingName));
    }
  }
  box.put("mindSets", mindSets);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final documentsDir = await getApplicationDocumentsDirectory();
  Hive.init(documentsDir.path);
  Hive.registerAdapter<MindSetObject>(MindSetObjectAdapter());
  runApp(const MindfulnessApp());
}

class MindfulnessApp extends StatefulWidget {
  const MindfulnessApp({super.key});

  @override
  State<MindfulnessApp> createState() => _MindfulnessAppState();
}

class _MindfulnessAppState extends State<MindfulnessApp> {
  Box<List<dynamic>>? _mindSetsBox;
  final List<MindSetObject> _mindSets = [];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAddNewMindset(MindSetObject mindSet) async {
    setState(() {
      _mindSets.add(mindSet);
      _mindSetsBox?.put("mindSets", _mindSets);
    });
  }

  void _onDeleteMindSet(MindSetObject mindSet) async {
    setState(() {
      _mindSets.remove(mindSet);
      _mindSetsBox?.put("mindSets", _mindSets);
    });
  }

  @override
  void initState() {
    super.initState();
    if (!Hive.isBoxOpen("mindfulness_app")) {
      Hive.openBox<List<dynamic>>("mindfulness_app").then((box) {
        // box.clear();
        setState(() {
          // applyTestData(box);
          _mindSetsBox = box;
          _mindSets.addAll(box.get("mindSets")?.cast<MindSetObject>() ?? []);
        });
      });
    } else {
      setState(() {
        final box = Hive.box<List<dynamic>>("mindfulness_app");
        _mindSetsBox = box;
        _mindSets.addAll(box.get("mindSets")?.cast<MindSetObject>() ?? []);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePage(
        mindSets: _mindSets,
        onDeleteMindSet: _onDeleteMindSet,
        onAddMindSet: _onAddNewMindset,
      ),
      CalendarPage(
        mindSets: _mindSets,
        onAddMindSet: _onAddNewMindset,
      ),
      AnalyticsPage(
        mindSets: _mindSets,
        onAddMindSet: _onAddNewMindset,
      ),
    ];
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
              child: pages.elementAt(_selectedIndex),
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
