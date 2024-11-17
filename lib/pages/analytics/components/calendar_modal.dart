import 'package:flutter/material.dart';
import 'package:mindfulness_app/components/mind_set_calendar.dart';
import 'package:mindfulness_app/models/mind_set_object.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarModal extends StatefulWidget {
  const CalendarModal(
      {super.key,
      required this.selectedTimeRange,
      required this.onChangeRange,
      required this.mindSets});

  final List<MindSetObject> mindSets;
  final (DateTime, DateTime) selectedTimeRange;
  final void Function((DateTime, DateTime)) onChangeRange;

  @override
  State<CalendarModal> createState() => _CalendarModalState();
}

class _CalendarModalState extends State<CalendarModal> {
  late (DateTime, DateTime) _selectedTimeRange;

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    final parsedStart = start ?? DateTime.now();
    widget.onChangeRange((parsedStart, end ?? parsedStart));
    if (start != null && end != null) {
      setState(() {
        _selectedTimeRange = (start, end);
      });
    }
  }

  @override
  initState() {
    super.initState();
    setState(() {
      _selectedTimeRange = widget.selectedTimeRange;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_selectedTimeRange);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          toolbarHeight: 80.0,
          leading: Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back))),
          title: Container(
              height: 60.0,
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Select time range",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  )))),
      body: MindSetCalendar(
          focusedDay: _selectedTimeRange.$1,
          selectedDay: _selectedTimeRange.$2,
          rangeStartDay: _selectedTimeRange.$1,
          rangeEndDay: _selectedTimeRange.$2,
          rangeSelectionMode: RangeSelectionMode.toggledOn,
          onRangeSelected: _onRangeSelected,
          mindSets: widget.mindSets),
    );
  }
}
