import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationServiceManager {
  static StreamSubscription<ServiceStatus>? _subscription;

  static void startMonitoring(BuildContext context) {
    // Cancel any previous subscription
    _subscription?.cancel();

    _subscription = Geolocator.getServiceStatusStream().listen((status) {
      if (status == ServiceStatus.disabled) {
        _showLocationDialog(context);
      }
    });
  }

  static void stopMonitoring() {
    _subscription?.cancel();
  }

  static void _showLocationDialog(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Location Required"),
        content: const Text("Please enable your location to continue using the app."),
        actions: [
          TextButton(
            onPressed: () async {
              navigator.pop(); // Close dialog
              await Geolocator.openLocationSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }
}
class LocationAwareWrapper extends StatefulWidget {
  final Widget child;

  const LocationAwareWrapper({super.key, required this.child});

  @override
  State<LocationAwareWrapper> createState() => _LocationAwareWrapperState();
}

class _LocationAwareWrapperState extends State<LocationAwareWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Check on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LocationServiceManager.startMonitoring(context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    LocationServiceManager.stopMonitoring();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
