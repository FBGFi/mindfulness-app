import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/models/mind_set_object.dart';
import 'package:mindfulness_app/pages/home/components/add_mind_set_modal.dart';
import 'package:mindfulness_app/pages/home/components/mind_sets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Box<MindSetObjectModel>? _mindSetsBox;
  Map<String, MindSetObject> _mindSets = {};

  void _onAddNew(MindSetObject mindSet) async {
    setState(() {
      _mindSets[DateTime.now().toIso8601String()] = mindSet;
      _mindSetsBox?.put("mindSets", MindSetObjectModel(mindSets: _mindSets));
    });
  }

  void onDeleteMindSet(String dateTime) async {
    setState(() {
      _mindSets.remove(dateTime);
      _mindSetsBox?.put("mindSets", MindSetObjectModel(mindSets: _mindSets));
    });
  }

  @override
  void initState() {
    super.initState();
    if (!Hive.isBoxOpen("mindfulness_app")) {
      Hive.openBox<MindSetObjectModel>("mindfulness_app").then((box) {
        setState(() {
          _mindSetsBox = box;
          _mindSets = box.get("mindSets")?.mindSets ?? {};
        });
      });
    } else {
      setState(() {
        final box = Hive.box<MindSetObjectModel>("mindfulness_app");
        _mindSetsBox = box;
        _mindSets = box.get("mindSets")?.mindSets ?? {};
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
