import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../sensors/pitchheel/pitchheel_service.dart';

final pitchHeelServiceProvider = Provider<PitchHeelService>((ref) {
  return PitchHeelService();
});

final pitchHeelProvider = StreamProvider<Map<String, double>>((ref) {
  final service = ref.read(pitchHeelServiceProvider);
  return service.pitchHeelStream;
});