import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/search_result_model.dart';

class SharedPrefHelper {
  static const String _showCase = 'showShowcase';
  static const String _speedButton = 'speedButton';
  static const String _preferences = 'preferences';
  static const String _placeFsqId = 'fsqId';
  static const String _alertId = 'alertId';
  static const String notificationTime = 'notificationTime';
  static const String _searchHistory = 'search_history';
  static const String _searchLocationHistory = 'search_location_history';
  static final installationTimeKey = 'installationTime';
  static final reviewDoneKey = 'reviewDone';

  static Future<bool> setShowcaseVisited(bool showCase) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(_showCase, showCase);
  }

  static Future<bool> getShowCase() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool showCase = preferences.getBool(_showCase) ?? true;
    return showCase;
  }

  static Future<bool> setSpeedButton(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(_speedButton, value);
  }

  static Future<bool> getSpeedButton() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool showCase = preferences.getBool(_speedButton) ?? true;
    return showCase;
  }

  static Future<bool> savePreference(String pref) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(_preferences, pref);
  }

  static Future<String?> getPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? preferencesList = preferences.getString(_preferences);
    if (preferencesList == null) {
      return null;
    }
    return preferencesList;
  }

  /// Notification Values

  static Future<bool> setPlaceFsqId(String fsqId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(_placeFsqId, fsqId);
  }

  static Future<String> getPlaceFsqId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String fsqId = preferences.getString(_placeFsqId) ?? '';
    return fsqId;
  }

  static Future<bool> setAlertId(String alertId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(_alertId, alertId);
  }

  static Future<String> getAlertId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String fsqId = preferences.getString(_alertId) ?? '';
    return fsqId;
  }

  static Future<bool> setNotificationTime(DateTime date) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(
        notificationTime, date.toIso8601String());
  }

  static Future<DateTime?> getNotificationTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? date = preferences.getString(notificationTime);
    if (date != null) {
      return DateTime.parse(date);
    } else {
      return null;
    }
  }

  static Future<List<SearchResult>> loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_searchHistory);
    if (historyJson != null) {
      final List<dynamic> jsonList = jsonDecode(historyJson);
      return jsonList.map((e) => SearchResult.fromJson(e)).toList();
    }
    return [];
  }

  static Future<void> saveSearchResult(SearchResult result) async {
    final prefs = await SharedPreferences.getInstance();
    List<SearchResult> history = await loadSearchHistory();
    history.add(result);
    if (history.length > 5) {
      history.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      history.removeAt(0); // Remove the oldest result
    }
    final historyJson = jsonEncode(history.map((e) => e.toJson()).toList());
    await prefs.setString(_searchHistory, historyJson);
  }

  static Future<List<SearchResult>> loadSearchLocationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_searchLocationHistory);
    if (historyJson != null) {
      final List<dynamic> jsonList = jsonDecode(historyJson);
      return jsonList.map((e) => SearchResult.fromJson(e)).toList();
    }
    return [];
  }

  static Future<void> saveSearchLocationHistory(SearchResult result) async {
    final prefs = await SharedPreferences.getInstance();
    List<SearchResult> history = await loadSearchLocationHistory();
    history.add(result);
    if (history.length > 5) {
      history.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      history.removeAt(0);
    }
    final historyJson = jsonEncode(history.map((e) => e.toJson()).toList());
    await prefs.setString(_searchLocationHistory, historyJson);
  }

  static Future<void> storeInstallationTime() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(installationTimeKey)) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt(installationTimeKey, currentTime);
    }
  }

  // Function to track the installation time
  static Future<int?> trackInstallationTime() async {
    final prefs = await SharedPreferences.getInstance();
    final installationTime = prefs.getInt(installationTimeKey);
    return installationTime;
  }

  /// review status
  static Future<void> setReviewDone(bool isDone) async {
    final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(reviewDoneKey, isDone);
    }

  static Future<bool> getReviewDoneStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isDone = prefs.getBool(reviewDoneKey);
    return isDone ?? false;
  }
}
