import 'package:flutter/material.dart';

class TimeColumnController {
  /// Current value of the column
  int _value;

  /// Scroll controller for the list wheel
  final FixedExtentScrollController scrollController;

  /// Min and max allowed values
  final int minValue;
  final int maxValue;

  /// Notifies listeners when value changes
  final ValueNotifier<int> valueNotifier;

  /// Create a controller with an initial value
  TimeColumnController({
    int initialValue = 0,
    required this.minValue,
    required this.maxValue,
  }) : _value = initialValue.clamp(minValue, maxValue),
        scrollController = FixedExtentScrollController(
            initialItem: initialValue.clamp(minValue, maxValue) - minValue
        ),
        valueNotifier = ValueNotifier(initialValue.clamp(minValue, maxValue));

  /// Current value of the column
  int get value => _value;

  /// Set the current value
  set value(int newValue) {
    final clampedValue = newValue.clamp(minValue, maxValue);
    _value = clampedValue;
    valueNotifier.value = clampedValue;
    scrollController.jumpToItem(clampedValue - minValue);
  }

  /// Jump to a specific value
  void jumpTo(int value) {
    this.value = value;
  }

  /// Animate to a specific value
  Future<void> animateTo(
      int value, {
        required Duration duration,
        required Curve curve,
      }) async {
    final clampedValue = value.clamp(minValue, maxValue);
    _value = clampedValue;
    valueNotifier.value = clampedValue;
    return scrollController.animateToItem(
      clampedValue - minValue,
      duration: duration,
      curve: curve,
    );
  }

  /// Update value from scroll position
  void updateValueFromScrollPosition(int position) {
    final newValue = position + minValue;
    if (_value != newValue) {
      _value = newValue;
      valueNotifier.value = newValue;
    }
  }

  /// Dispose resources
  void dispose() {
    scrollController.dispose();
    valueNotifier.dispose();
  }
}