import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/models/mind_set_object.dart';
import 'package:mindfulness_app/pages/home/components/add_mind_set_modal.dart';
import 'package:mindfulness_app/pages/home/components/mind_sets.dart';
import 'package:mindfulness_app/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
      required this.onDeleteMindSet,
      required this.onAddMindSet,
      required this.mindSets});

  final Function(MindSetObject mindSet) onDeleteMindSet;
  final Function(MindSetObject mindSet) onAddMindSet;
  final List<MindSetObject> mindSets;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        mindSets: getMindsetsOfDay(widget.mindSets, DateTime.now()),
        onDeleteMindSet: widget.onDeleteMindSet,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) =>
                  AddMindSetModal(onAddNew: widget.onAddMindSet));
        },
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: const Icon(Icons.add),
      ),
    );
  }
}
