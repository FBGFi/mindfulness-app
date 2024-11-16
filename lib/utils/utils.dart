import 'package:flutter/material.dart';
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
