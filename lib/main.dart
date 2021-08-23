import 'dart:io';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../provider/restaurant_provider.dart';
import 'common/navigation.dart';
import 'data/api/api_service.dart';
import 'data/model/restaurant_list.dart';
import 'helper/background_service.dart';
import 'helper/notification_helper.dart';
import 'pages/home_page.dart';
import 'pages/restaurant_detail_page.dart';
import 'pages/restaurant_favourite_page.dart';
import 'style/styles.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => RestaurantProvider(apiService: ApiService()),
        child: MaterialApp(
          title: 'Restaurant',
          theme: ThemeData(
            primaryColor: primaryColor,
            accentColor: secondaryColor,
            scaffoldBackgroundColor: Colors.white,
            textTheme: myTextTheme,
            appBarTheme: AppBarTheme(
              textTheme: myTextTheme.apply(bodyColor: Colors.black),
              elevation: 0,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                primary: secondaryColor,
                textStyle: TextStyle(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(0),
                  ),
                ),
              ),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: secondaryColor,
              unselectedItemColor: Colors.grey,
            ),
          ),
          navigatorKey: navigatorKey,
          initialRoute: HomePage.routeName,
          routes: {
            HomePage.routeName: (context) => HomePage(),
            RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
                  restaurant:
                      ModalRoute.of(context)?.settings.arguments as Restaurant,
                ),
            RestaurantFavouritePage.routeName: (context) =>
                RestaurantFavouritePage(),
          },
        ));
  }
}
