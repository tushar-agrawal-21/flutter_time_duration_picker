import 'package:flutter/material.dart';
import 'time_picker_column.dart';
import 'time_column_config.dart';
import 'time_picker_theme.dart';

class TimeDurationPicker extends StatefulWidget {
  /// Initial time to display in the picker
  final DateTime? initialTime;

  /// List of column configurations that define the picker structure
  final List<TimeColumnConfig> columns;

  /// Height of the picker widget
  final double height;

  /// Spacing between columns
  final double columnSpacing;

  /// Theme for the time picker
  final TimeDurationPickerTheme theme;

  /// Callback when time values change
  final Function(Map<String, int> values)? onChanged;

  /// Show separator lines
  final bool showSeparatorLines;

  /// Position of separator lines
  final double? upperLinePosition;
  final double? lowerLinePosition;

  /// Width of the picker
  final double? width;

  const TimeDurationPicker({
    Key? key,
    this.initialTime,
    required this.columns,
    this.height = 168,
    this.columnSpacing = 12.0,
    this.theme = const TimeDurationPickerTheme(),
    this.onChanged,
    this.showSeparatorLines = true,
    this.upperLinePosition,
    this.lowerLinePosition,
    this.width,
  }) : super(key: key);

  @override
  State<TimeDurationPicker> createState() => TimeDurationPickerState();
}

class TimeDurationPickerState extends State<TimeDurationPicker> {
  late Map<String, ValueNotifier<int>> _selectedValues;
  late Map<String, FixedExtentScrollController> _controllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _selectedValues = {};
    _controllers = {};

    for (var column in widget.columns) {
      int initialValue = _getInitialValue(column);
      _selectedValues[column.id] = ValueNotifier(initialValue);
      _controllers[column.id] = FixedExtentScrollController(initialItem: initialValue);
    }
  }

  int _getInitialValue(TimeColumnConfig column) {
    if (widget.initialTime == null) return column.defaultValue;

    switch (column.type) {
      case TimeColumnType.hour:
        return widget.initialTime!.hour;
      case TimeColumnType.minute:
        return widget.initialTime!.minute;
      case TimeColumnType.second:
        return widget.initialTime!.second;
      case TimeColumnType.custom:
        return column.defaultValue;
    }
  }

  @override
  void didUpdateWidget(TimeDurationPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If columns configuration has changed, reinitialize controllers
    if (oldWidget.columns.length != widget.columns.length ||
        oldWidget.initialTime != widget.initialTime) {
      _initializeControllers();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          if (widget.showSeparatorLines) _buildSeparatorLines(),
          _buildColumns(),
        ],
      ),
    );
  }

  Widget _buildSeparatorLines() {
    return Positioned(
      top: 0,
      left: 40,
      right: 40,
      bottom: 30,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 0.5,
            color: widget.theme.separatorColor,
          ),
          SizedBox(height: widget.upperLinePosition ?? 50),
          Container(
            width: double.infinity,
            height: 0.5,
            color: widget.theme.separatorColor,
          ),
        ],
      ),
    );
  }

  Widget _buildColumns() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildColumnWidgets(),
    );
  }

  List<Widget> _buildColumnWidgets() {
    List<Widget> columnWidgets = [];

    for (int i = 0; i < widget.columns.length; i++) {
      final column = widget.columns[i];

      // Add the column
      columnWidgets.add(
        TimePickerColumn(
          controller: _controllers[column.id]!,
          valueNotifier: _selectedValues[column.id]!,
          config: column,
          theme: widget.theme,
          onSelectedItemChanged: (value) {
            _selectedValues[column.id]!.value = value;

            if (widget.onChanged != null) {
              Map<String, int> values = {};
              for (var entry in _selectedValues.entries) {
                values[entry.key] = entry.value.value;
              }
              widget.onChanged!(values);
            }
          },
        ),
      );

      // Add spacing and separator if not the last column
      if (i < widget.columns.length - 1) {
        // Add separator if specified
        if (column.separator != null) {
          columnWidgets.add(
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.columnSpacing),
              child: SizedBox(
                width: column.separatorWidth ?? 10,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: widget.theme.itemExtent,
                  physics: const NeverScrollableScrollPhysics(),
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: 1,
                    builder: (context, index) {
                      return Text(
                        column.separator!,
                        style: widget.theme.separatorTextStyle,
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        } else {
          // Add normal spacing
          columnWidgets.add(SizedBox(width: widget.columnSpacing));
        }
      }
    }

    return columnWidgets;
  }

  /// Get all current selected values as a map
  Map<String, int> getSelectedValues() {
    Map<String, int> values = {};
    for (var entry in _selectedValues.entries) {
      values[entry.key] = entry.value.value;
    }
    return values;
  }

  /// Get selected time as DateTime object
  DateTime getSelectedDateTime() {
    final now = DateTime.now();

    int hour = 0;
    int minute = 0;
    int second = 0;

    for (var column in widget.columns) {
      int value = _selectedValues[column.id]!.value;

      switch (column.type) {
        case TimeColumnType.hour:
          hour = value;
          break;
        case TimeColumnType.minute:
          minute = value;
          break;
        case TimeColumnType.second:
          second = value;
          break;
        case TimeColumnType.custom:
        // Custom columns don't affect DateTime
          break;
      }
    }

    return DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
      second,
    );
  }

  /// Jump to specific values for each column
  void jumpToValues(Map<String, int> values) {
    values.forEach((columnId, value) {
      if (_controllers.containsKey(columnId)) {
        _controllers[columnId]!.jumpToItem(value);
        _selectedValues[columnId]!.value = value;
      }
    });
  }
}