enum TimeColumnType {
  hour,
  minute,
  second,
  custom,
}

class TimeColumnConfig {
  /// Unique identifier for this column
  final String id;

  /// Type of time column
  final TimeColumnType type;

  /// Min and max values for this column
  final int minValue;
  final int maxValue;

  /// Default value to use when no initialTime is provided
  final int defaultValue;

  /// Width of this column
  final double width;

  /// Optional separator text to display after this column
  final String? separator;

  /// Width of the separator
  final double? separatorWidth;

  /// Optional formatter for displaying values
  final String Function(int)? valueFormatter;

  /// Optional label for the column (e.g., "hr", "min")
  final String? label;

   TimeColumnConfig({
    required this.id,
    required this.type,
    this.minValue = 0,
    int? maxValue,
    int? defaultValue,
    this.width = 40,
    this.separator,
    this.separatorWidth,
    this.valueFormatter,
    this.label,
  }) :
        maxValue = maxValue ?? _getDefaultMaxValue(type),
        defaultValue = defaultValue ?? 0;

  static int _getDefaultMaxValue(TimeColumnType type) {
    switch (type) {
      case TimeColumnType.hour:
        return 23;
      case TimeColumnType.minute:
      case TimeColumnType.second:
        return 59;
      case TimeColumnType.custom:
        return 99; // Default for custom type
    }
  }

  /// Factory for creating an hours column
  factory TimeColumnConfig.hours({
    String id = 'hours',
    int minValue = 0,
    int maxValue = 23,
    int defaultValue = 0,
    double width = 40,
    String? separator,
    double? separatorWidth,
    String Function(int)? valueFormatter,
    String? label,
  }) {
    return TimeColumnConfig(
      id: id,
      type: TimeColumnType.hour,
      minValue: minValue,
      maxValue: maxValue,
      defaultValue: defaultValue,
      width: width,
      separator: separator,
      separatorWidth: separatorWidth,
      valueFormatter: valueFormatter,
      label: label,
    );
  }

  /// Factory for creating a minutes column
  factory TimeColumnConfig.minutes({
    String id = 'minutes',
    int minValue = 0,
    int maxValue = 59,
    int defaultValue = 0,
    double width = 40,
    String? separator,
    double? separatorWidth,
    String Function(int)? valueFormatter,
    String? label,
  }) {
    return TimeColumnConfig(
      id: id,
      type: TimeColumnType.minute,
      minValue: minValue,
      maxValue: maxValue,
      defaultValue: defaultValue,
      width: width,
      separator: separator,
      separatorWidth: separatorWidth,
      valueFormatter: valueFormatter ?? ((value) => value < 10 ? '0$value' : value.toString()),
      label: label,
    );
  }

  /// Factory for creating a seconds column
  factory TimeColumnConfig.seconds({
    String id = 'seconds',
    int minValue = 0,
    int maxValue = 59,
    int defaultValue = 0,
    double width = 40,
    String? separator,
    double? separatorWidth,
    String Function(int)? valueFormatter,
    String? label,
  }) {
    return TimeColumnConfig(
      id: id,
      type: TimeColumnType.second,
      minValue: minValue,
      maxValue: maxValue,
      defaultValue: defaultValue,
      width: width,
      separator: separator,
      separatorWidth: separatorWidth,
      valueFormatter: valueFormatter ?? ((value) => value < 10 ? '0$value' : value.toString()),
      label: label,
    );
  }

  /// Factory for creating a custom column
  factory TimeColumnConfig.custom({
    required String id,
    int minValue = 0,
    required int maxValue,
    int defaultValue = 0,
    double width = 40,
    String? separator,
    double? separatorWidth,
    String Function(int)? valueFormatter,
    String? label,
  }) {
    return TimeColumnConfig(
      id: id,
      type: TimeColumnType.custom,
      minValue: minValue,
      maxValue: maxValue,
      defaultValue: defaultValue,
      width: width,
      separator: separator,
      separatorWidth: separatorWidth,
      valueFormatter: valueFormatter,
      label: label,
    );
  }

  /// Factory for creating a label column (non-scrollable text)
  factory TimeColumnConfig.label({
    required String id,
    required String text,
    double width = 60,
  }) {
    return TimeColumnConfig(
      id: id,
      type: TimeColumnType.custom,
      minValue: 0,
      maxValue: 0,
      width: width,
      valueFormatter: (_) => text,
    );
  }
}
