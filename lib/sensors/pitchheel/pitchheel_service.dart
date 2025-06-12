import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

class PitchHeelService {
  PitchHeelService();

  double? _lastPitch;
  double? _lastHeel;
  final double _alpha = 0.01; // smoothing factor

  Stream<Map<String, double>> get pitchHeelStream {
    return accelerometerEvents.map((event) {
      final x = event.x;
      final y = event.y;
      final z = event.z;

      final rawHeel = atan2(-x, sqrt(y * y + z * z)) * (180 / pi);
      final rawPitch = (atan2(y, z) * (180 / pi))-90;

      final smoothedPitch = _applySmoothing(rawPitch, isPitch: true);
      final smoothedHeel = _applySmoothing(rawHeel, isPitch: false);

      return {
        'pitch': smoothedPitch,
        'heel': smoothedHeel,
      };
    });
  }

  double _applySmoothing(double currentValue, {required bool isPitch}) {
    if (isPitch) {
      if (_lastPitch == null) {
        _lastPitch = currentValue;
      } else {
        _lastPitch = _lastPitch! + _alpha * (currentValue - _lastPitch!);
      }
      return _lastPitch!;
    } else {
      if (_lastHeel == null) {
        _lastHeel = currentValue;
      } else {
        _lastHeel = _lastHeel! + _alpha * (currentValue - _lastHeel!);
      }
      return _lastHeel!;
    }
  }
}