import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';

import '../helper/background_service.dart';
import '../helper/date_time_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  Future<bool> scheduledRestaurant(bool value) async {
    if (value) {
      print('Scheduling Random Restaurant Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling Random Restaurant Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
