import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static String launchDateKey = "launchDate";

//Launch Date
  static setLaunchDate(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(launchDateKey, date.toIso8601String());
  }

  static Future<DateTime?> getLaunchDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dateTimeStringValue = prefs.getString(launchDateKey) ?? "";
    return DateTime.tryParse(dateTimeStringValue);
    // return DateTime(2021, 07, 07); // For testing purposes
  }
}
