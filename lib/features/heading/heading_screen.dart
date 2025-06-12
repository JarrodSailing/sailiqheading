import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'heading_provider.dart';

class HeadingScreen extends ConsumerWidget {
  const HeadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headingAsync = ref.watch(headingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Heading Sensor')),
      body: Center(
        child: headingAsync.when(
          data: (heading) => Text(
            '${heading.toStringAsFixed(0)}°',
            style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
          ),
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
        ),
      ),
    );
  }
}