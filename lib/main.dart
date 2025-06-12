import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/sensors/sensor_screen.dart';

void main() {
  runApp(const ProviderScope(child: SailIqHeadingApp()));
}

class SailIqHeadingApp extends StatelessWidget {
  const SailIqHeadingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SailIQ Heading',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SensorScreen(),
    );
  }
}