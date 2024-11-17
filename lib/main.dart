import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mindfulness_app/models/mind_set_object.dart';
import 'package:mindfulness_app/pages/analytics/analytics.dart';
import 'package:mindfulness_app/pages/calendar/calendar.dart';
import 'package:mindfulness_app/pages/home/home.dart';
import 'package:path_provider/path_provider.dart';

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
        setState(() {
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
