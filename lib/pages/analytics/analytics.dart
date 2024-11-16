import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/models/mind_set_object.dart';
import 'package:mindfulness_app/utils/utils.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  Box<MindSetObjectModel>? _mindSetsBox;
  Map<String, MindSetObject> _mindSets = {};

  double _getTodayMin() {
    final today = DateTime.now();
    return DateTime(today.year, today.month, today.day, 0, 0, 0)
        .millisecondsSinceEpoch
        .toDouble();
  }

  double _getTodayMax() {
    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day, 0, 0, 0)
        .millisecondsSinceEpoch
        .toDouble();
    return todayMidnight + 60 * 60 * 24 * 1000;
  }

  List<double> _calculateLinearStops() {
    final dateValues = _mindSets.entries
        .map(
          (entry) =>
              DateTime.parse(entry.key).millisecondsSinceEpoch.toDouble(),
        )
        .toList();
    final min = dateValues[0];
    final max = dateValues[dateValues.length - 1];
    final range = max - min;
    final stops = dateValues.map((date) => (date - min) / range).toList();
    return stops;
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
    // TODO have to sort here
    final values = _mindSets.entries
        .map((entry) => (
              DateTime.parse(entry.key).millisecondsSinceEpoch.toDouble(),
              getMindSetRankValue(entry.value)?.toDouble() ?? 0
            ))
        .toList();
    final spots = values.map((entry) {
      return FlSpot(entry.$1, entry.$2);
    }).toList();
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
              DateFormat("EEE, d MMMM yyyy").format(DateTime.now()),
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            )),
        body: Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Padding(
                padding: EdgeInsets.all(10),
                child: LineChart(LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        showingIndicators: _mindSets.entries
                            .map((entry) =>
                                getMindSetRankValue(entry.value)?.floor() ?? 0)
                            .toList(),
                        gradient: LinearGradient(
                            colors: _mindSets.entries
                                .map((entry) => getMindSetColor(entry.value))
                                .toList(),
                            stops: _calculateLinearStops()),
                        spots: spots,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, p1, p2, p3) =>
                              FlDotCirclePainter(
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
                    minX: _getTodayMin(),
                    maxX: _getTodayMax(),
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
                          interval: 60 * 60 * 1000 * 6,
                          getTitlesWidget: (value, meta) {
                            String text;
                            if (value == _getTodayMin() ||
                                value == _getTodayMax()) {
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
                        ))))))));
  }
}
