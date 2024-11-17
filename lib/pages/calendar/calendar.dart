import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/components/mind_set_calendar.dart';
import 'package:mindfulness_app/models/mind_set_object.dart';
import 'package:mindfulness_app/components/mind_sets.dart';
import 'package:mindfulness_app/utils/utils.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage(
      {super.key, required this.onAddMindSet, required this.mindSets});

  final Function(MindSetObject mindSet) onAddMindSet;
  final List<MindSetObject> mindSets;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            DateFormat("EEE, d MMMM yyyy").format(_selectedDay),
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          )),
      body: Column(
        children: [
          MindSetCalendar(
              focusedDay: DateTime.now(),
              selectedDay: _selectedDay,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
              },
              mindSets: widget.mindSets),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: MindSets(
            mindSets: getMindsetsOfDay(widget.mindSets, _selectedDay),
          ))
        ],
      ),
    );
  }
}
