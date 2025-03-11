import 'package:flutter/material.dart';

class TimeDurationPickerTheme {
  /// Height of each item in the wheel
  final double itemExtent;

  /// Text style for selected items
  final TextStyle selectedTextStyle;

  /// Text style for unselected items
  final TextStyle unselectedTextStyle;

  /// Text style for separator items
  final TextStyle separatorTextStyle;

  /// Color of separator lines
  final Color separatorColor;

  const TimeDurationPickerTheme({
    this.itemExtent = 55,
    this.selectedTextStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    this.unselectedTextStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Color(0x2E757575),
    ),
    this.separatorTextStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    this.separatorColor = Colors.black,
  });

  /// Create a copy of this theme with some properties replaced
  TimeDurationPickerTheme copyWith({
    double? itemExtent,
    TextStyle? selectedTextStyle,
    TextStyle? unselectedTextStyle,
    TextStyle? separatorTextStyle,
    Color? separatorColor,
  }) {
    return TimeDurationPickerTheme(
      itemExtent: itemExtent ?? this.itemExtent,
      selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
      unselectedTextStyle: unselectedTextStyle ?? this.unselectedTextStyle,
      separatorTextStyle: separatorTextStyle ?? this.separatorTextStyle,
      separatorColor: separatorColor ?? this.separatorColor,
    );
  }
}
