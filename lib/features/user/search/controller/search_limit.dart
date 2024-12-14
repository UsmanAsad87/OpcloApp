import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../restaurant/controller/places_controller.dart';

class SearchLimiter {
  static const _searchCountKey = 'search_count';

  // static const _searchTimestampsKey = 'search_timestamps';
  static const String _lastSearchTimeKey = "lastSearchTime";
  static const _freeUserLimit = 10;
  static const _timeLimitInHours = 24;

  static Future<bool> canSearch() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSearchTimeString = prefs.getString(_lastSearchTimeKey);
    final searchCount = prefs.getInt(_searchCountKey) ?? 0;

    final now = DateTime.now();

    if (lastSearchTimeString != null) {
      final lastSearchTime = DateTime.parse(lastSearchTimeString);
      if (now
          .difference(lastSearchTime)
          .inHours >= _timeLimitInHours) {
        await prefs.setString(_lastSearchTimeKey, now.toIso8601String());
        await prefs.setInt(_searchCountKey, 0);
        return true;
      }
    }
    return searchCount < _freeUserLimit;
  }

  // Increment the search count
  static Future<void> incrementSearchCount() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    final lastSearchTimeString = prefs.getString(_lastSearchTimeKey);
    final lastSearchTime = lastSearchTimeString != null ? DateTime.parse(
        lastSearchTimeString) : null;

    if (lastSearchTime == null || now
        .difference(lastSearchTime)
        .inHours >= _timeLimitInHours) {
      await prefs.setString(_lastSearchTimeKey, now.toIso8601String());
      await prefs.setInt(_searchCountKey, 1);
    } else {
      // Increment the count
      final searchCount = prefs.getInt(_searchCountKey) ?? 0;
      await prefs.setInt(_searchCountKey, searchCount + 1);
    }
  }

  // Get remaining time to search again
  static Future<String> timeRemainingToSearch() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSearchTimeString = prefs.getString(_lastSearchTimeKey);

    final lastSearchTime = lastSearchTimeString == null ? DateTime.now()
        : DateTime.parse(lastSearchTimeString);
    final now = DateTime.now();

    final elapsed = now.difference(lastSearchTime);
    final remaining = const Duration(hours: _timeLimitInHours) - elapsed;
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    final remainingTime = '$hours hours, $minutes minutes';
    return remainingTime;
  }
}