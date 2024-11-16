import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/models/mind_set_object.dart';
import 'package:mindfulness_app/pages/home/components/add_mind_set_modal.dart';
import 'package:mindfulness_app/pages/home/components/mind_sets.dart';
import 'package:mindfulness_app/utils/constants.dart';

void applyTestData(Box<List<MindSetObject>> box) {
  // box.clear();
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Box<List<MindSetObject>>? _mindSetsBox;
  final List<MindSetObject> _mindSets = [];

  void _onAddNew(MindSetObject mindSet) async {
    setState(() {
      _mindSets.add(mindSet);
      _mindSetsBox?.put("mindSets", _mindSets);
    });
  }

  void onDeleteMindSet(MindSetObject mindSet) async {
    setState(() {
      _mindSets.remove(mindSet);
      _mindSetsBox?.put("mindSets", _mindSets);
    });
  }

  @override
  void initState() {
    super.initState();
    if (!Hive.isBoxOpen("mindfulness_app")) {
      Hive.openBox<List<MindSetObject>>("mindfulness_app").then((box) {
        setState(() {
          _mindSetsBox = box;
          _mindSets.addAll(box.get("mindSets") ?? []);
        });
      });
    } else {
      setState(() {
        final box = Hive.box<List<MindSetObject>>("mindfulness_app");
        // applyTestData(box);
        _mindSetsBox = box;
        _mindSets.addAll(box.get("mindSets") ?? []);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            DateFormat("EEE, d MMMM yyyy").format(DateTime.now()),
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          )),
      body: MindSets(
        mindSets: _mindSets,
        onDeleteMindSet: onDeleteMindSet,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => AddMindSetModal(onAddNew: _onAddNew));
        },
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: const Icon(Icons.add),
      ),
    );
  }
}
