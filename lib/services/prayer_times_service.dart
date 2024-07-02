// lib/services/prayer_times_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/prayer_times.dart';

class PrayerTimesService {
  Future<PrayerTimes> fetchPrayerTimes(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'http://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=2'));

    if (response.statusCode == 200) {
      return PrayerTimes.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load prayer times');
    }
  }
}
