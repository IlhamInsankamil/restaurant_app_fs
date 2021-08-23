import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/notification_helper.dart';
import '../pages/restaurant_detail_page.dart';
import '../provider/scheduling_provider.dart';
import 'restaurant_list_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;
  final NotificationHelper _notificationHelper = NotificationHelper();

  List<Widget> _listWidget = [
    RestaurantListPage(),
    ChangeNotifierProvider<SchedulingProvider>(
      create: (_) => SchedulingProvider(),
      child: SettingsPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(RestaurantDetailPage.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bottomNavIndex == 0 ? _listWidget[0] : _listWidget[1],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_restaurant),
            label: 'Recommendation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (selected) {
          setState(() {
            _bottomNavIndex = selected;
          });
        },
      ),
    );
  }
}
