import 'package:flutter_compass/flutter_compass.dart';

class HeadingService {
  HeadingService();

  double? _lastHeading;
  final double _alpha = 0.1;  // smoothing factor (1.0, no smotting at all, 0.05 heaving smoothing)

  Stream<double> get headingStream {
    return FlutterCompass.events!.map((event) {
      final rawHeading = event.heading ?? 0.0;
      final normalizedHeading = _normalizeHeading(rawHeading);
      return _applySmoothing(normalizedHeading);
    });
  }

  double _normalizeHeading(double heading) {
    return heading < 0 ? 360 + heading : heading;
  }

  double _applySmoothing(double currentHeading) {
    if (_lastHeading == null) {
      _lastHeading = currentHeading;
    } else {
      double diff = currentHeading - _lastHeading!;
      if (diff > 180) diff -= 360;
      if (diff < -180) diff += 360;

      _lastHeading = (_lastHeading! + _alpha * diff) % 360;
      if (_lastHeading! < 0) _lastHeading = 360 + _lastHeading!;
    }
    return _lastHeading!;
  }
}