import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../heading/heading_provider.dart';
import '../cogspeed/cogspeed_provider.dart';
import '../../core/permissions/permissions_service.dart';
import 'package:geolocator/geolocator.dart';
import '../../sensors/heading/heading_service.dart';
import '../../sensors/cogspeed/cogspeed_service.dart';
import '../../sensors/pitchheel/pitchheel_service.dart';
import '../pitchheel/pitchheel_provider.dart';

class SensorScreen extends ConsumerStatefulWidget {
  const SensorScreen({super.key});

  @override
  ConsumerState<SensorScreen> createState() => _SensorScreenState();
}

class _SensorScreenState extends ConsumerState<SensorScreen> {
  bool _isLoading = true;
  String _error = '';
  late HeadingService _headingService;
  late CogSpeedService _cogSpeedService;
  late PitchHeelService _pitchHeelService;
  Stream<double>? _headingStream;
  Stream<Position>? _positionStream;
  Stream<Map<String, double>>? _pitchHeelStream;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      final permissionService = PermissionsService();
      final locationGranted = await permissionService.requestLocationPermissions();

      if (!locationGranted) {
        setState(() {
          _error = "Location permission denied.";
          _isLoading = false;
        });
        return;
      }

      _headingService = ref.read(headingServiceProvider);
      _cogSpeedService = ref.read(cogSpeedServiceProvider);
      _pitchHeelService = ref.read(pitchHeelServiceProvider);

      setState(() {
        _headingStream = _headingService.headingStream;
        _positionStream = _cogSpeedService.positionStream;
        _pitchHeelStream = _pitchHeelService.pitchHeelStream;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Initialization failed: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error.isNotEmpty) {
      return Scaffold(body: Center(child: Text(_error)));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("SailIQ Sensors")),
      body: StreamBuilder<double>(
        stream: _headingStream,
        builder: (context, headingSnapshot) {
          return StreamBuilder<Position>(
            stream: _positionStream,
            builder: (context, positionSnapshot) {
              return StreamBuilder<Map<String, double>>(
                stream: _pitchHeelStream,
                builder: (context, pitchHeelSnapshot) {
                  final heading = headingSnapshot.data ?? 0.0;
                  final cog = (positionSnapshot.data?.heading ?? 0.0).toStringAsFixed(0);
                  final sog = ((positionSnapshot.data?.speed ?? 0.0) * 1.94384).toStringAsFixed(1);
                  final pitch = (pitchHeelSnapshot.data?['pitch'] ?? 0.0).toStringAsFixed(0);
                  final heel = (pitchHeelSnapshot.data?['heel'] ?? 0.0).toStringAsFixed(0);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Heading: ${heading.toStringAsFixed(0)}°", style: const TextStyle(fontSize: 40)),
                      const SizedBox(height: 20),
                      Text("COG: $cog°", style: const TextStyle(fontSize: 40)),
                      const SizedBox(height: 20),
                      Text("Speed: $sog kn", style: const TextStyle(fontSize: 40)),
                      const SizedBox(height: 20),
                      Text("Pitch: $pitch°", style: const TextStyle(fontSize: 40)),
                      const SizedBox(height: 20),
                      Text("Heel: $heel°", style: const TextStyle(fontSize: 40)),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}