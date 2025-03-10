import 'package:flutter/material.dart';
import 'package:flutter_time_duration_picker/flutter_time_duration_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Duration Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime? selectedTime;
  final GlobalKey<TimeDurationPickerState> _pickerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Duration Picker Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Basic example with hours and minutes
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Basic Time Picker (Hours:Minutes)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TimeDurationPicker(
                      key: _pickerKey,
                      initialTime: DateTime.now(),
                      columns: [
                        TimeColumnConfig.hours(
                          separator: ':',
                        ),
                        TimeColumnConfig.minutes(),
                      ],
                      onChanged: (values) {
                        setState(() {
                          selectedTime = _pickerKey.currentState?.getSelectedDateTime();
                        });
                      },
                    ),
                    if (selectedTime != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Selected time: ${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Advanced example with custom configuration
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Custom Time Duration Picker',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TimeDurationPicker(
                      initialTime: DateTime.now(),
                      theme: const TimeDurationPickerTheme(
                        selectedTextStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        unselectedTextStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        separatorTextStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        separatorColor: Colors.blue,
                      ),
                      columns: [
                        TimeColumnConfig.hours(
                          separator: 'h',
                          separatorWidth: 20,
                        ),
                        TimeColumnConfig.minutes(
                          separator: 'm',
                          separatorWidth: 20,
                        ),
                        TimeColumnConfig.seconds(
                          separator: 's',
                          separatorWidth: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Example with custom range and labels
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Custom Range Picker',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TimeDurationPicker(
                      columns: [
                        TimeColumnConfig.custom(
                          id: 'days',
                          minValue: 0,
                          maxValue: 31,
                          width: 40,
                        ),
                        TimeColumnConfig.label(
                          id: 'daysLabel',
                          text: 'days',
                          width: 50,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
