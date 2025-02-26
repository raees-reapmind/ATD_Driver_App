import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class BackgroundService {
  Future<void> init();

  Future<void> startService();
}

class BackgroundServiceImpl implements BackgroundService {
  late final FlutterBackgroundService service;

  @override
  Future<void> init() async {
    service = FlutterBackgroundService();

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_foreground', // id
      'MY FOREGROUND SERVICE', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.low, // importance must be at low or higher level
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'App running in background',
        initialNotificationContent: 'using location',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: false,

        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,

        // you have to enable background fetch capability on xcode project
        onBackground: onIosBackground,
      ),
    );
  }

  static onStart(ServiceInstance service) {
    service.on('data').listen((event) {
      debugPrint(event.toString());
    });

    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  FutureOr<bool> onIosBackground(ServiceInstance service) {
    //todo implement for ios
    return true;
  }

  @override
  Future<void> startService() async {
    await service.startService();
  }
}
