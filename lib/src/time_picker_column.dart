import 'package:flutter/material.dart';
import 'time_column_config.dart';
import 'time_picker_theme.dart';

class TimePickerColumn extends StatelessWidget {
  final FixedExtentScrollController controller;
  final ValueNotifier<int> valueNotifier;
  final TimeColumnConfig config;
  final TimeDurationPickerTheme theme;
  final Function(int) onSelectedItemChanged;

  const TimePickerColumn({
    Key? key,
    required this.controller,
    required this.valueNotifier,
    required this.config,
    required this.theme,
    required this.onSelectedItemChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: config.width,
      child: ListWheelScrollView.useDelegate(
        itemExtent: theme.itemExtent,
        controller: controller,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onSelectedItemChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: config.maxValue - config.minValue + 1,
          builder: (context, index) {
            final actualValue = index + config.minValue;
            return ValueListenableBuilder<int>(
              valueListenable: valueNotifier,
              builder: (context, selectedValue, _) {
                return _buildItem(actualValue, selectedValue == actualValue);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildItem(int value, bool isSelected) {
    String displayText = config.valueFormatter != null
        ? config.valueFormatter!(value)
        : _defaultValueFormatter(value);

    return Text(
      displayText,
      style: isSelected
          ? theme.selectedTextStyle
          : theme.unselectedTextStyle,
      textAlign: TextAlign.center,
    );
  }

  String _defaultValueFormatter(int value) {
    switch (config.type) {
      case TimeColumnType.minute:
      case TimeColumnType.second:
        return value < 10 ? '0$value' : value.toString();
      default:
        return value.toString();
    }
  }
}
