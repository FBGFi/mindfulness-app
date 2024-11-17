import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/models/mind_set_object.dart';
import 'package:mindfulness_app/utils/constants.dart';

/// Calculated lightness multiplier should be between 0.4 and 0.7, lower value indicating higher match
double calculateLightness(double value, int minValue, int maxValue) {
  final absoluteValue = value.abs();
  final range = maxValue - minValue;
  return ((0.4 + (0.2 * ((maxValue - absoluteValue) / range))) * 100)
          .roundToDouble() /
      100;
}

Color getColorByRank(double? value) {
  if (value != null) {
    if (value >= 7) {
      return HSLColor.fromColor(Colors.green)
          .withLightness(calculateLightness(value, 7, 10))
          .toColor();
    } else if (value >= 3) {
      return HSLColor.fromColor(Colors.lightGreen)
          .withLightness(calculateLightness(value, 3, 7))
          .toColor();
    } else if (value >= 0) {
      return HSLColor.fromColor(Colors.yellow)
          .withLightness(calculateLightness(value, 0, 3))
          .toColor();
    } else if (value <= -7) {
      return HSLColor.fromColor(Colors.red)
          .withLightness(calculateLightness(value, 7, 10))
          .toColor();
    } else if (value <= -3) {
      return HSLColor.fromColor(Colors.orange)
          .withLightness(calculateLightness(value, 3, -7))
          .toColor();
    } else if (value < 0) {
      return HSLColor.fromColor(Colors.yellow)
          .withLightness(calculateLightness(value, 0, 3))
          .toColor();
    }
  }
  return Colors.grey;
}

double? getMindSetRankValue(MindSetObject mindSet) {
  final category = MIND_SET_VALUES[mindSet.category];
  final value = category != null ? category[mindSet.feeling] : null;
  return value?.toDouble();
}

Color getMindSetColor(MindSetObject mindSet) {
  return getColorByRank(getMindSetRankValue(mindSet));
}

List<MindSetObject> getMindsetsOfDay(
    List<MindSetObject> mindSets, DateTime day) {
  final formattedDay = DateFormat("yyyy-MM-dd").format(day);
  final List<MindSetObject> dayMindSets = [];
  for (var entry in mindSets) {
    if (DateFormat("yyyy-MM-dd")
            .format(DateTime.fromMillisecondsSinceEpoch(entry.date)) ==
        formattedDay) {
      dayMindSets.add(entry);
    }
  }
  return dayMindSets;
}

List<MindSetObject> getMindSetsFromRange(
    List<MindSetObject> mindSets, DateTime start, DateTime end) {
  final formattedStart = DateFormat("yyyy-MM-dd").format(start);
  final formattedEnd = DateFormat("yyyy-MM-dd").format(end);
  final List<MindSetObject> dayMindSets = [];
  for (var entry in mindSets) {
    final formattedEntryDate = DateFormat("yyyy-MM-dd")
        .format(DateTime.fromMillisecondsSinceEpoch(entry.date));
    if (formattedEntryDate.compareTo(formattedStart) >= 0 &&
        formattedEntryDate.compareTo(formattedEnd) <= 0) {
      dayMindSets.add(entry);
    }
  }
  return dayMindSets;
}

double calculateAverageRank(List<MindSetObject> mindSets) {
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

double toFixed(double value) {
  return (value * 100).round() / 100;
}
