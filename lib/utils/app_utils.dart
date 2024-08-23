import 'package:flutter/material.dart';
import 'package:gtravel/models/calendar.dart';

class AppUtils {
  static colorChecker(ColorEnum color, [bool isShade = false]) {
    return switch (color) {
      ColorEnum.orange =>
        isShade ? Colors.orange.shade50 : Colors.orange.shade200,
      ColorEnum.blue => isShade ? Colors.blue.shade50 : Colors.blue.shade200,
      ColorEnum.purple =>
        isShade ? Colors.purple.shade50 : Colors.purple.shade200,
      _ => isShade ? Colors.pink.shade50 : Colors.pink.shade200
    };
  }
}
