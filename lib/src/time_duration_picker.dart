import 'package:flutter/material.dart';
import 'time_picker_column.dart';
import 'time_column_config.dart';
import 'time_picker_theme.dart';
import 'time_column_controller.dart';

class TimeDurationPicker extends StatefulWidget {
  /// List of column configurations that define the picker structure
  final List<TimeColumnConfig> columns;

  /// List of controllers for each column
  final List<TimeColumnController> controllers;

  /// Height of the picker widget
  final double height;

  /// Spacing between columns
  final double columnSpacing;

  /// Theme for the time picker
  final TimeDurationPickerTheme theme;

  /// Callback when time values change
  final Function(List<int> values)? onChanged;

  /// Show separator lines
  final bool showSeparatorLines;

  /// Position of separator lines
  final double? upperLinePosition;
  final double? lowerLinePosition;

  /// Width of the picker
  final double? width;

  const TimeDurationPicker({
    super.key,
    required this.columns,
    required this.controllers,
    this.height = 168,
    this.columnSpacing = 12.0,
    this.theme = const TimeDurationPickerTheme(),
    this.onChanged,
    this.showSeparatorLines = true,
    this.upperLinePosition,
    this.lowerLinePosition,
    this.width,
  }) : assert(columns.length == controllers.length,
  'Number of columns must match the number of controllers');

  @override
  State<TimeDurationPicker> createState() => _TimeDurationPickerState();
}

class _TimeDurationPickerState extends State<TimeDurationPicker> {
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
      final controller = widget.controllers[i];

      // Add the column
      columnWidgets.add(
        TimePickerColumn(
          controller: controller,
          config: column,
          theme: widget.theme,
          onValueChanged: (value) {
            if (widget.onChanged != null) {
              final values = widget.controllers.map((c) => c.value).toList();
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
}