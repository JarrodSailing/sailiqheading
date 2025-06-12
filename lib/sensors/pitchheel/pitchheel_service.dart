import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

class PitchHeelService {
  PitchHeelService();

  Stream<Map<String, double>> get pitchHeelStream {
    return accelerometerEvents.map((event) {
      final x = event.x;
      final y = event.y;
      final z = event.z;

      final heel = atan2(-x, sqrt(y * y + z * z)) * (180 / pi);
      final pitch = atan2(y, z) * (180 / pi);

      return {
        'pitch': pitch,
        'heel': heel,
      };
    });
  }
}