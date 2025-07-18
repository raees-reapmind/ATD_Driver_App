import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? _socket;
  Timer? _timer;

  /// Connect to WebSocket
  void connect() {
    _socket = IO.io(
      'https://your-backend.com', // Replace with your backend URL
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      debugPrint("[socket-test] ✅ Connected to Socket");
      _startSendingLocation();
    });

    _socket!.onDisconnect((_) => debugPrint("[socket-test] ❌ Disconnected from Socket"));
  }

  /// Start sending location every 5 seconds
  void _startSendingLocation() async {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      Position position = await _getCurrentLocation();
      _sendLocation(position.latitude, position.longitude);
    });
  }

  /// Get current location
  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Send location data to WebSocket
  void _sendLocation(double latitude, double longitude) {
    if (_socket != null && _socket!.connected) {
      final data = {
        "latitude": latitude,
        "longitude": longitude,
        "timestamp": DateTime.now().toIso8601String(),
      };
      _socket!.emit("sendLocation", data);
      debugPrint("[socket-test] 📡 Sent: $data");
    }
  }

  /// Close connection
  void disconnect() {
    _timer?.cancel();
    _socket?.disconnect();
  }
}
