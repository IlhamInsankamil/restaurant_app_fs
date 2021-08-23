import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app3/provider/restaurant_provider.dart';

import '../provider/scheduling_provider.dart';
import '../widgets/custom_dialog.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: _buildSettingList(context),
    );
  }
}

Widget _buildSettingList(BuildContext context) {
  return ListView(
    children: [
      Material(
        child: ListTile(
          title: Text('Dark Theme'),
          trailing: Switch.adaptive(
            value: false,
            onChanged: (value) => customDialog(context),
          ),
        ),
      ),
      Material(
        child: ListTile(
          title: Text('Enable Notification'),
          trailing: Consumer<SchedulingProvider>(
            builder: (context, scheduled, _) {
              bool status =
                  Provider.of<RestaurantProvider>(context, listen: false)
                      .dailyNotification;
              return Switch.adaptive(
                value: status,
                onChanged: (value) async {
                  if (Platform.isIOS) {
                    customDialog(context);
                  } else {
                    Provider.of<RestaurantProvider>(context, listen: false)
                        .turnDailyNotification(value);
                    scheduled.scheduledRestaurant(value);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(value
                            ? 'Daily Notification Enabled'
                            : 'Daily Notification Disabled')));
                  }
                },
              );
            },
          ),
        ),
      ),
    ],
  );
}
