import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:atd/main.dart'; // <-- Add this import at the top if not present

class LocationAwareWrapper extends StatefulWidget {
  final Widget child;
  const LocationAwareWrapper({super.key, required this.child});

  @override
  State<LocationAwareWrapper> createState() => _LocationAwareWrapperState();
}

class _LocationAwareWrapperState extends State<LocationAwareWrapper> {
  StreamSubscription<geo.ServiceStatus>? _serviceStatusStream;
  bool _dialogOpen = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _listenToServiceStatus();
  }

  Future<void> _checkLocationPermission() async {
    final permission = await perm.Permission.location.request();
    final serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();

    if (permission.isGranted && !serviceEnabled && !_dialogOpen) {
      _showLocationDialog();
    }
  }

  void _showLocationDialog() {
    _dialogOpen = true;
    showDialog(
      context: navigatorKey.currentContext!, // Use global navigatorKey context
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Location Required"),
        content: const Text("Please turn on location services."),
        actions: [
          TextButton(
            onPressed: () async {
              await geo.Geolocator.openLocationSettings();
            },
            child: const Text("Turn On Location"),
          ),
        ],
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          _dialogOpen = false;
        });
      } else {
        _dialogOpen = false;
      }
    });
  }

  void _listenToServiceStatus() {
    _serviceStatusStream =
        geo.Geolocator.getServiceStatusStream().listen((status) {
      if (status == geo.ServiceStatus.disabled && !_dialogOpen) {
        _showLocationDialog();
      } else if (status == geo.ServiceStatus.enabled && _dialogOpen) {
        if (navigatorKey.currentState?.canPop() ?? false) {
          navigatorKey.currentState?.pop();
        }
        // _dialogOpen will be reset in .then() of showDialog
      }
    });
  }

  @override
  void dispose() {
    _serviceStatusStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
