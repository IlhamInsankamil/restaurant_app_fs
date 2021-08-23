import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String localDataPrefs = 'localData';

  readLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(localDataPrefs)!);
  }

  saveLocalData(value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(localDataPrefs, json.encode(value));
  }

  removeLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(localDataPrefs);
  }
}
