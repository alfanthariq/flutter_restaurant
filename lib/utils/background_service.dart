import 'dart:isolate';
import 'dart:math';

import 'dart:ui';

import 'package:flutter_restaurant/data/model/restaurant_list.dart';
import 'package:flutter_restaurant/data/repos/api_repos.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utils/notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _service;
  static String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._createObject();

  factory BackgroundService() {
    if (_service == null) {
      _service = BackgroundService._createObject();
    }
    return _service!;
  }

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    try {
      final NotificationHelper _notificationHelper = NotificationHelper();
      RestaurantList? result = await ApiRepository().getRestaurant();

      final _random = new Random();
      int next(int min, int max) => min + _random.nextInt(max - min);

      if (result.restaurants.isNotEmpty) {
        await _notificationHelper.showNotification(
            flutterLocalNotificationsPlugin,
            result.restaurants[next(0, result.restaurants.length - 1)]);

        _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
        _uiSendPort?.send(null);
      }
    } catch (e) {}
  }
}
