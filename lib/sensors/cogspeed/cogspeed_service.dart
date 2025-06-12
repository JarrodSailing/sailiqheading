import 'package:geolocator/geolocator.dart';

class CogSpeedService {
  CogSpeedService();

  Stream<Position> get positionStream {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1,
      ),
    );
  }

  double getCog(Position position) {
    return position.heading;
  }

  double getSpeed(Position position) {
    // Speed is in m/s, convert to knots
    return (position.speed * 1.94384);
  }
}