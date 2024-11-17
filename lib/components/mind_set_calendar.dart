import 'package:flutter/material.dart';
import 'package:mindfulness_app/models/mind_set_object.dart';
import 'package:mindfulness_app/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class MindSetCalendar extends StatefulWidget {
  MindSetCalendar(
      {super.key,
      required this.selectedDay,
      this.onDaySelected,
      required this.mindSets,
      required this.focusedDay,
      this.rangeSelectionMode,
      this.rangeStartDay,
      this.rangeEndDay,
      this.onRangeSelected,
      this.calendarFormat = CalendarFormat.month});

  final DateTime selectedDay;
  final DateTime focusedDay;
  final Function(DateTime, DateTime)? onDaySelected;
  final Function(DateTime?, DateTime?, DateTime)? onRangeSelected;
  final List<MindSetObject> mindSets;
  final CalendarFormat calendarFormat;
  final RangeSelectionMode? rangeSelectionMode;
  final DateTime? rangeStartDay;
  final DateTime? rangeEndDay;

  @override
  State<MindSetCalendar> createState() => _MindSetCalendarState();
}

class _MindSetCalendarState extends State<MindSetCalendar> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late CalendarFormat _calendarFormat;
  DateTime? _rangeStartDay;
  DateTime? _rangeEndDay;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (widget.onDaySelected != null) {
      widget.onDaySelected!(selectedDay, focusedDay);
    }
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    if (widget.onRangeSelected != null) {
      widget.onRangeSelected!(start, end, focusedDay);
    }
    setState(() {
      _rangeStartDay = start;
      _rangeEndDay = end;
      _focusedDay = focusedDay;
    });
  }

  @override
  initState() {
    super.initState();
    setState(() {
      _calendarFormat = widget.calendarFormat;
      _selectedDay = widget.selectedDay;
      _focusedDay = widget.focusedDay;
      _rangeStartDay = widget.rangeStartDay;
      _rangeEndDay = widget.rangeEndDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar<MindSetObject>(
      focusedDay: _focusedDay,
      firstDay: DateTime.utc(2024),
      lastDay: DateTime.utc(2054),
      rangeStartDay: _rangeStartDay,
      rangeEndDay: _rangeEndDay,
      daysOfWeekHeight: 40,
      weekNumbersVisible: true,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: _onDaySelected,
      onRangeSelected: _onRangeSelected,
      rangeSelectionMode:
          widget.rangeSelectionMode ?? RangeSelectionMode.toggledOff,
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
