import 'dart:convert';
import 'dart:io';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_restaurant/cubit/restaurant_detail_cubit.dart';
import 'package:flutter_restaurant/data/repos/api_repos.dart';
import 'package:flutter_restaurant/ui/view/main_view.dart';
import 'package:flutter_restaurant/ui/view/restaurant_detail_view.dart';
import 'package:flutter_restaurant/utils/background_service.dart';
import 'package:flutter_restaurant/utils/navigation.dart';
import 'package:flutter_restaurant/utils/notification_helper.dart';
import 'package:flutter_restaurant/utils/theme_data.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

String initialRoute = '/';
String notifPayload = "";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    notifPayload = notificationAppLaunchDetails!.payload ?? "";
    initialRoute = "/detail";
  }

  final BackgroundService _service = BackgroundService();
  _service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Theme(
        data: theme.brightness == Brightness.light
            ? ThemeData.from(colorScheme: ColorScheme.light())
            : ThemeData.from(colorScheme: ColorScheme.dark()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Restaurant",
          theme: lightTheme,
          navigatorKey: navigatorKey,
          initialRoute: initialRoute,
          routes: {
            '/': (context) => MainView(),
            '/detail': (context) {
              Map<String, dynamic> json;
              if (ModalRoute.of(context)?.settings.arguments != null) {
                json = jsonDecode(
                    ModalRoute.of(context)?.settings.arguments as String);
              } else {
                json = jsonDecode(notifPayload);
              }
              return BlocProvider<RestaurantDetailCubit>(
                create: (context) => RestaurantDetailCubit(ApiRepository()),
                child: RestaurantDetailView(
                  id: json["id"],
                  imgId: json["pictureId"],
                ),
              );
            }
          },
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
        ));
  }
}
