import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkChecker {
  static final NetworkChecker _instance = NetworkChecker._internal();
  factory NetworkChecker() => _instance;
  NetworkChecker._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription; // Updated type
  GlobalKey<NavigatorState>? navigatorKey;
  bool _dialogShown = false;

  // Initialize the network checker with the navigator key
  void initialize(GlobalKey<NavigatorState> key) {
    navigatorKey = key;

    // Listen for connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // Check if any of the connectivity results are not 'none'
      final hasConnection = results.any((result) => result != ConnectivityResult.none);

      if (!hasConnection) {
        _showNoConnectionDialog();
      } else {
        _dismissDialog();
      }
    });
  }

  // Show no connection dialog
  void _showNoConnectionDialog() {
    final context = navigatorKey?.currentContext;
    
    if (context == null || _dialogShown) return; // Avoid showing dialog if context is null or dialog is already shown
    debugPrint('context == null || _dialogShown: ${context == null || _dialogShown}');
    _dialogShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon indicating no internet
              const Icon(
                Icons.signal_wifi_off,
                color: Colors.black,
                size: 50,
              ),
              const SizedBox(height: 16),
              // Dialog Title
              Text(
                'No Internet Connection',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Dialog content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Please check your network connection and try again.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: Colors.black54,
                      ),
                ),
              ),
              // const SizedBox(height: 24),
              // // Retry button
              // ElevatedButton(
              //   onPressed: () async {
              //     var status = await _connectivity.checkConnectivity();
              //     debugPrint('status: $status');
              //     final hasConnection = status != ConnectivityResult.none;
              //     if (hasConnection) {
              //       _dismissDialog();
              //     }
              //     // If no connection, the dialog remains open.
              //   },
              //   style: ElevatedButton.styleFrom(
              //     primary: Colors.yellow, // Retry button color
              //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              //   ),
              //   child: const Text(
              //     'Try Again',
              //     style: TextStyle(color: Colors.black, fontSize: 16),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Dismiss the dialog if it is shown
  void _dismissDialog() {
    if (!_dialogShown) return;

    final context = navigatorKey?.currentContext;
    if (context != null && Navigator.of(context).canPop()) {
      Navigator.of(context).pop(); // Dismiss the dialog
    }

    _dialogShown = false;
  }

  // Dispose the network listener
  void dispose() {
    _subscription?.cancel();
  }
}