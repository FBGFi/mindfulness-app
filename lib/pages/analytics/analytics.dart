import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/models/mind_set_object.dart';
import 'package:mindfulness_app/pages/analytics/components/calendar_modal.dart';
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
    return todayMidnight + 60 * 60 * 24 * 1000;
  }

  double _calculateInterval() {
    final dayAsMilliseconds = 60 * 60 * 24 * 1000;
    final diff = _selectedTimeRange.$2.millisecondsSinceEpoch -
        _selectedTimeRange.$1.millisecondsSinceEpoch;
    final multiplier = diff / dayAsMilliseconds;
    return 60 * 60 * 1000 * 6 * (1 + multiplier);
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
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            _formatRangeText(),
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          )),
      body: Container(
          height: MediaQuery.of(context).size.height / 2,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: LineChart(LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      showingIndicators: widget.mindSets
                          .map((entry) =>
                              getMindSetRankValue(entry)?.floor() ?? 0)
                          .toList(),
                      gradient: LinearGradient(
                          colors: widget.mindSets
                              .map((entry) => getMindSetColor(entry))
                              .toList(),
                          stops: _calculateLinearStops()),
                      spots: spots,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, p1, p2, p3) => FlDotCirclePainter(
                            radius: 5, color: getColorByRank(spot.y)),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (touchedSpot) =>
                              getColorByRank(touchedSpot.y),
                          getTooltipItems: (touchedSpots) => touchedSpots
                              .map(
                                (spot) => LineTooltipItem(
                                    spot.y.toString(),
                                    const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              )
                              .toList())),
                  minY: -12,
                  maxY: 12,
                  minX: _getRangeMin(),
                  maxX: _getRangeMax(),
                  titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                        reservedSize: 30,
                        showTitles: true,
                        interval: _calculateInterval(),
                        getTitlesWidget: (value, meta) {
                          String text;
                          if (value == _getRangeMin() ||
                              value == _getRangeMax()) {
                            text = "";
                          } else {
                            text = DateFormat("HH:mm").format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    value.round()));
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 4,
                            child: Text(text),
                          );
                        },
                      ))))))),
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
