import 'package:flutter/material.dart';
import 'time_column_config.dart';
import 'time_picker_theme.dart';
import 'time_column_controller.dart';

class TimePickerColumn extends StatelessWidget {
  final TimeColumnController controller;
  final TimeColumnConfig config;
  final TimeDurationPickerTheme theme;
  final Function(int)? onValueChanged;

  const TimePickerColumn({
    super.key,
    required this.controller,
    required this.config,
    required this.theme,
    this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: config.width,
      child: ListWheelScrollView.useDelegate(
        itemExtent: theme.itemExtent,
        controller: controller.scrollController,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          final actualValue = index + config.minValue;
          controller.updateValueFromScrollPosition(actualValue);
          if (onValueChanged != null) {
            onValueChanged!(actualValue);
          }
        },
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: config.maxValue - config.minValue + 1,
          builder: (context, index) {
            final actualValue = index + config.minValue;
            return ValueListenableBuilder<int>(
              valueListenable: controller.valueNotifier,
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
      style: isSelected ? theme.selectedTextStyle : theme.unselectedTextStyle,
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