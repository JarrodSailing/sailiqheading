import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cogspeed_provider.dart';
import '../../core/permissions/permissions_service.dart';
import 'package:geolocator/geolocator.dart';

class CogSpeedScreen extends ConsumerStatefulWidget {
  const CogSpeedScreen({super.key});

  @override
  ConsumerState<CogSpeedScreen> createState() => _CogSpeedScreenState();
}

class _CogSpeedScreenState extends ConsumerState<CogSpeedScreen> {
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      final permissionService = PermissionsService();
      final granted = await permissionService.requestLocationPermissions();

      if (!granted) {
        setState(() {
          _error = "Location permission denied.";
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Location init failed: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final positionAsync = ref.watch(positionProvider);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error.isNotEmpty) {
      return Scaffold(
        body: Center(child: Text(_error)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("COG & Speed")),
      body: Center(
        child: positionAsync.when(
          data: (position) {
            final cog = (position.heading ?? 0.0).toStringAsFixed(0);
            final sog = ((position.speed ?? 0.0) * 1.94384).toStringAsFixed(1);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("COG: $cog°", style: const TextStyle(fontSize: 60)),
                const SizedBox(height: 40),
                Text("Speed: $sog kn", style: const TextStyle(fontSize: 60)),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text("Error: $e"),
        ),
      ),
    );
  }
}