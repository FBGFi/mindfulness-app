import 'package:flutter/material.dart';
import 'package:mindfulness_app/models/mind_set_object.dart';
import 'package:mindfulness_app/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class MindSetCalendar extends StatefulWidget {
  MindSetCalendar(
      {super.key,
      required this.selectedDay,
      required this.onDaySelected,
      required this.mindSets,
      this.calendarFormat = CalendarFormat.month});

  final DateTime selectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final List<MindSetObject> mindSets;
  final CalendarFormat calendarFormat;

  @override
  State<MindSetCalendar> createState() => _MindSetCalendarState();
}

class _MindSetCalendarState extends State<MindSetCalendar> {
  late CalendarFormat _calendarFormat;

  @override
  initState() {
    super.initState();
    setState(() {
      _calendarFormat = widget.calendarFormat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar<MindSetObject>(
      focusedDay: DateTime.now(),
      firstDay: DateTime.utc(2024),
      lastDay: DateTime.utc(2054),
      daysOfWeekHeight: 40,
      weekNumbersVisible: true,
      selectedDayPredicate: (day) {
        return isSameDay(widget.selectedDay, day);
      },
      onDaySelected: widget.onDaySelected,
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
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          final mindSetsOfDay = getMindsetsOfDay(widget.mindSets, day);
          return Container(
              width: 16,
              height: 16,
              color: mindSetsOfDay.isEmpty
                  ? Colors.grey
                  : getColorByRank(calculateAverageRank(mindSetsOfDay)),
              child: Center(
                  child: Text(
                mindSetsOfDay.length.toString(),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              )));
        },
      ),
    );
  }
}
