import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../sensors/heading/heading_service.dart';

final headingServiceProvider = Provider<HeadingService>((ref) {
  return HeadingService();
});

final headingProvider = StreamProvider<double>((ref) {
  final service = ref.read(headingServiceProvider);
  return service.headingStream;
});