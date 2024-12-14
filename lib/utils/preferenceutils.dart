import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceKey {
  static const String loggedIn = "logged_in";
  static const String accessToken = "access_token";
  static const String userId = "user_id";
  static const String serveruserId = "serveruserId";
  static const String firstName = "first_name";
  static const String lastName = "last_name";
  static const String email = "email";
  static const String phoneNumber = "phone_number";
  static const String deviceID = "deviceID";
  static const String phoneVerified = "phone_verified";
  static const String appleEmail = "email";
  static const String appleUserName = "dispalyname";
  static const String epostCard1 = "epostCard1";
  static const String epostCard2 = "epostCard2";
  static const String epostCard3 = "epostCard3";
  static const String latitude = "latitude";
  static const String longitude = "longitude";
  static const String tripID = "tripID";
  static const String tripStartTime = "tripStartTime";
  static const String liveTripId = "liveTripId";
  static const String minDistance = "minDistance";
  static const String minDuration = "minDuration";
  static const String liveTripName = "liveTripName";
  static const String liveTripTypeID = "liveTripTypeID";
}

class PreferenceUtils {
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences?> init() async {
    _prefsInstance = await SharedPreferences.getInstance();
    return _prefsInstance;
  }

  static String getString(String key, [String? defValue]) {
    return _prefsInstance!.getString(key) ?? (defValue ?? "");
  }

  static int? getInt(
    String? key,
  ) {
    return _prefsInstance!.getInt(key!) ?? 1;
  }

  static bool? getBool(
    String? key,
  ) {
    return _prefsInstance!.getBool(key!) ?? false;
  }

  static double? getDouble(
    String? key,
  ) {
    return _prefsInstance!.getDouble(key!) ?? 0.0;
  }

  static Future<bool> setInt(String key, int value) async {
    var prefs = await _instance;

    return prefs.setInt(key, value);
  }

  static Future<bool> setDouble(String key, double value) async {
    var prefs = await _instance;

    return prefs.setDouble(key, value);
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;

    return prefs.setString(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    var prefs = await _instance;

    return prefs.setBool(key, value);
  }

  static Future<bool> containsKey(String key) async {
    var prefs = await _instance;

    return prefs.containsKey(key);
  }

  static Future<bool> clear() async {
    var prefs = await _instance;
    _prefsInstance!.clear();
    SharedPreferences prefsd = await SharedPreferences.getInstance();
    await prefsd.clear();
    return await prefs.clear();
  }

  static Future<bool> dataClearFromKey(String key) async {
    var prefs = await _instance;

    return prefs.remove(key);
  }
}
