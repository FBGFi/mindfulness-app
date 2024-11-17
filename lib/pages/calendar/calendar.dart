import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/models/mind_set_object.dart';
import 'package:mindfulness_app/pages/home/components/mind_sets.dart';
import 'package:mindfulness_app/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

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
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  double _calculateAverageRank(List<MindSetObject> mindSets) {
    if (mindSets.isEmpty) return 0;
    double totalRank = 0;
    mindSets.forEach((mindSet) {
      final rank = getMindSetRankValue(mindSet);
      if (rank != null) {
        totalRank += rank;
      }
    });
    return totalRank / mindSets.length;
  }

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
          TableCalendar<MindSetObject>(
            focusedDay: DateTime.now(),
            firstDay: DateTime.utc(2024),
            lastDay: DateTime.utc(2054),
            daysOfWeekHeight: 40,
            weekNumbersVisible: true,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            availableCalendarFormats: const {
              CalendarFormat.month: "Month",
              CalendarFormat.week: "Week"
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: (day) {
              return [
                MindSetObject(category: "AAA", feeling: "BBB", notes: "CCC")
              ];
            },
            calendarBuilders: CalendarBuilders(
              // prioritizedBuilder: (context, day, focusedDay) {
              //   return Center(child: Text(day.day.toString()));
              // },
              markerBuilder: (context, day, events) {
                final mindSetsOfDay = getMindsetsOfDay(widget.mindSets, day);
                return Container(
                    width: 16,
                    height: 16,
                    color: mindSetsOfDay.isEmpty
                        ? Colors.grey
                        : getColorByRank(_calculateAverageRank(mindSetsOfDay)),
                    child: Center(
                        child: Text(
                      mindSetsOfDay.length.toString(),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    )));
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: MindSets(
                  mindSets: getMindsetsOfDay(widget.mindSets, _selectedDay),
                  onDeleteMindSet: (str) {}))
        ],
      ),
    );
  }
}
