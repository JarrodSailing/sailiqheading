import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../sensors/cogspeed/cogspeed_service.dart';
import 'package:geolocator/geolocator.dart';

final cogSpeedServiceProvider = Provider<CogSpeedService>((ref) {
  return CogSpeedService();
});

final positionProvider = StreamProvider<Position>((ref) {
  final service = ref.read(cogSpeedServiceProvider);
  return service.positionStream;
});