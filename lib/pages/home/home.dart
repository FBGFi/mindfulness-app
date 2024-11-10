import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/pages/home/components/mind_sets.dart';
import 'package:mindfulness_app/utils/mind_set_object.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TODO get from global state
  final Map<String, MindSetObject> _mindSets = {
    DateTime.now().toIso8601String():
        MindSetObject(feeling: "Sad", notes: "Some notes"),
  };

  void _onAddNew() {
    setState(() {
      _mindSets[DateTime.now().toIso8601String()] = MindSetObject(
          feeling:
              "New feeling with very long name to check overflowing right now just so it goes correctly",
          notes:
              "New notes with very long name to check overflowing right now just so it goes correctly");
    });
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
      body: MindSets(mindSets: _mindSets),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddNew,
        tooltip: "Add new",
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: const Icon(Icons.add),
      ),
    );
  }
}
