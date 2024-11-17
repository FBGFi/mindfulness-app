import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/models/mind_set_object.dart';
import 'package:mindfulness_app/pages/analytics/components/calendar_modal.dart';
import 'package:mindfulness_app/utils/constants.dart';
import 'package:mindfulness_app/utils/utils.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage(
      {super.key, required this.onAddMindSet, required this.mindSets});

  final Function(MindSetObject mindSet) onAddMindSet;
  final List<MindSetObject> mindSets;

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  (DateTime, DateTime) _selectedTimeRange = (DateTime.now(), DateTime.now());

  void _onChangeRange((DateTime, DateTime) selectedTimeRange) {
    setState(() {
      _selectedTimeRange = selectedTimeRange;
    });
  }

  double _getRangeMin() {
    final start = _selectedTimeRange.$1;
    return DateTime(start.year, start.month, start.day, 0, 0, 0)
        .millisecondsSinceEpoch
        .toDouble();
  }

  double _getRangeMax() {
    final end = _selectedTimeRange.$2;
    final todayMidnight = DateTime(end.year, end.month, end.day, 0, 0, 0)
        .millisecondsSinceEpoch
        .toDouble();
    return todayMidnight + DAY_AS_MILLISECONDS;
  }

  double _getRangeAverage() {
    final rangeMindSets = getMindSetsFromRange(
        widget.mindSets, _selectedTimeRange.$1, _selectedTimeRange.$2);
    return calculateAverageRank(rangeMindSets);
  }

  double _getTotalAverage() {
    return calculateAverageRank(widget.mindSets);
  }

  String _formatRangeText() {
    final formatted = (
      DateFormat("EEE, d MMMM yyyy").format(_selectedTimeRange.$1),
      DateFormat("EEE, d MMMM yyyy").format(_selectedTimeRange.$2)
    );
    if (formatted.$1 == formatted.$2) {
      return formatted.$1;
    }
    return '${formatted.$1} - ${formatted.$2}';
  }

  List<double> _calculateLinearStops() {
    if (widget.mindSets.isEmpty) return [];
    final dateValues = widget.mindSets
        .map(
          (entry) => entry.date.toDouble(),
        )
        .toList();
    final min = dateValues[0];
    final max = dateValues[dateValues.length - 1];
    final range = max - min;
    final stops = dateValues.map((date) => (date - min) / range).toList();
    return stops;
  }

  @override
  Widget build(BuildContext context) {
    final values = widget.mindSets
        .map((entry) => (
              (entry.date).toDouble(),
              getMindSetRankValue(entry)?.toDouble() ?? 0
            ))
        .toList();
    final spots = values.map((entry) {
      return FlSpot(entry.$1, entry.$2);
    }).toList();

    final rangeAverage = _getRangeAverage();
    final totalAverage = _getTotalAverage();
    final rangeBar = LineChartBarData(
      gradient: LinearGradient(
          colors:
              widget.mindSets.map((entry) => getMindSetColor(entry)).toList(),
          stops: _calculateLinearStops()),
      spots: spots,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, p1, p2, p3) =>
            FlDotCirclePainter(radius: 5, color: getColorByRank(spot.y)),
      ),
    );
    final rangeAverageBar = LineChartBarData(
      spots: [
        FlSpot(_getRangeMin(), rangeAverage),
        FlSpot(_getRangeMax(), rangeAverage),
      ],
      dotData: const FlDotData(show: false),
      color: getColorByRank(rangeAverage),
    );
    final totalAverageBar = LineChartBarData(
      spots: [
        FlSpot(_getRangeMin(), totalAverage),
        FlSpot(_getRangeMax(), totalAverage),
      ],
      dotData: const FlDotData(show: false),
      color: getColorByRank(totalAverage),
    );

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            _formatRangeText(),
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          )),
      body: Column(
        children: [
          Expanded(
              child: ListView(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: LineChart(LineChartData(
                          lineBarsData: [
                            rangeAverageBar,
                            totalAverageBar,
                            rangeBar,
                          ],
                          lineTouchData: const LineTouchData(
                            handleBuiltInTouches: false,
                          ),
                          minY: -12,
                          maxY: 12,
                          minX: _getRangeMin(),
                          maxX: _getRangeMax(),
                          titlesData: const FlTitlesData(
                              show: true,
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                minIncluded: false,
                                maxIncluded: false,
                              )),
                              bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                reservedSize: 0,
                              ))))))),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(220),
                          border: Border.all(
                              width: 3,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withAlpha(200))),
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Text("Range average: ",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary)),
                                    Text(toFixed(rangeAverage).toString(),
                                        style: TextStyle(
                                            color:
                                                getColorByRank(rangeAverage))),
                                  ]),
                                  Row(children: [
                                    Text("Total average: ",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary)),
                                    Text(toFixed(totalAverage).toString(),
                                        style: TextStyle(
                                            color:
                                                getColorByRank(totalAverage))),
                                  ]),
                                ],
                              ),
                              Icon(
                                rangeAverage < totalAverage
                                    ? Icons.trending_down
                                    : rangeAverage == totalAverage
                                        ? Icons.trending_flat
                                        : Icons.trending_up,
                                size: 34,
                                color: getColorByRank(
                                    totalAverage.abs() - rangeAverage.abs()),
                              ),
                            ],
                          ))))
            ],
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => CalendarModal(
                      selectedTimeRange: _selectedTimeRange,
                      onChangeRange: _onChangeRange,
                      mindSets: widget.mindSets,
                    ));
          },
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: const Icon(Icons.calendar_month)),
    );
  }
}
