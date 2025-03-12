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
  // Controllers for the basic time picker
  late TimeColumnController hourController;
  late TimeColumnController minuteController;

  // Controllers for the advanced time picker
  late TimeColumnController advHourController;
  late TimeColumnController advMinuteController;
  late TimeColumnController advSecondController;

  // Controllers for the custom range picker
  late TimeColumnController daysController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with current time
    final now = DateTime.now();

    // Basic time picker controllers
    hourController =
        TimeColumnController(initialValue: now.hour, minValue: 0, maxValue: 23);

    minuteController = TimeColumnController(
        initialValue: now.minute, minValue: 0, maxValue: 59);

    // Advanced time picker controllers
    advHourController =
        TimeColumnController(initialValue: now.hour, minValue: 0, maxValue: 23);

    advMinuteController = TimeColumnController(
        initialValue: now.minute, minValue: 0, maxValue: 59);

    advSecondController = TimeColumnController(
        initialValue: now.second, minValue: 0, maxValue: 59);

    // Custom range picker controller
    daysController =
        TimeColumnController(initialValue: 0, minValue: 0, maxValue: 31);
  }

  @override
  void dispose() {
    // Dispose all controllers
    hourController.dispose();
    minuteController.dispose();
    advHourController.dispose();
    advMinuteController.dispose();
    advSecondController.dispose();
    daysController.dispose();
    super.dispose();
  }

  // Helper to get selected time as formatted string
  String get formattedSelectedTime {
    return '${hourController.value}:${minuteController.value.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Duration Picker Demo'),
      ),
      body: SingleChildScrollView(
        child: Center(
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
                        columns: [
                          TimeColumnConfig.hours(
                            controller: hourController,
                            separator: ':',
                          ),
                          TimeColumnConfig.minutes(
                            controller: minuteController
                          ),
                        ],
                        onChanged: (values) {
                          setState(() {
                            // State will update from ValueNotifier
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Selected time: $formattedSelectedTime',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Set to midnight
                              hourController.value = 0;
                              minuteController.value = 0;
                              setState(() {});
                            },
                            child: const Text('Set to 00:00'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              // Set to noon
                              hourController.value = 12;
                              minuteController.value = 0;
                              setState(() {});
                            },
                            child: const Text('Set to 12:00'),
                          ),
                        ],
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
                            controller: advHourController
                          ),
                          TimeColumnConfig.minutes(
                            separator: 'm',
                            separatorWidth: 20,
                            controller: advMinuteController
                          ),
                          TimeColumnConfig.seconds(
                            separator: 's',
                            separatorWidth: 20,
                            controller: advSecondController
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: ValueListenableBuilder<int>(
                          valueListenable: advHourController.valueNotifier,
                          builder: (context, hourValue, _) {
                            return ValueListenableBuilder<int>(
                              valueListenable:
                                  advMinuteController.valueNotifier,
                              builder: (context, minuteValue, _) {
                                return ValueListenableBuilder<int>(
                                  valueListenable:
                                      advSecondController.valueNotifier,
                                  builder: (context, secondValue, _) {
                                    return Text(
                                      'Selected time: $hourValue:${minuteValue.toString().padLeft(2, '0')}:${secondValue.toString().padLeft(2, '0')}',
                                      style: const TextStyle(fontSize: 16),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Animate to random time
                          advHourController.animateTo(
                            (DateTime.now().millisecondsSinceEpoch % 24)
                                .toInt(),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                          advMinuteController.animateTo(
                            (DateTime.now().millisecondsSinceEpoch % 60)
                                .toInt(),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                          advSecondController.animateTo(
                            (DateTime.now().millisecondsSinceEpoch % 60)
                                .toInt(),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text('Animate to Random Time'),
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
                            controller: daysController
                          ),
                          TimeColumnConfig.label(
                            id: 'daysLabel',
                            text: 'days',
                            width: 50,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: ValueListenableBuilder<int>(
                          valueListenable: daysController.valueNotifier,
                          builder: (context, daysValue, _) {
                            return Text(
                              'Selected days: $daysValue',
                              style: const TextStyle(fontSize: 16),
                            );
                          },
                        ),
                      ),
                      Slider(
                        min: 0,
                        max: 31,
                        divisions: 31,
                        value: daysController.value.toDouble(),
                        onChanged: (value) {
                          daysController.value = value.toInt();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
