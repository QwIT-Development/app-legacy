import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:refilc/helpers/subject.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc_kreta_api/models/lesson.dart';

class ServerSyncProvider {
  static const String _baseUrl = 'https://legacy-la.devbeni.lol';

  String? _deviceId;

  Future<void> registerAndSync({
    required String deviceId,
    required String pushToken,
    required String bundleId,
    required String liveActivityColor,
    required List<Lesson> todayLessons,
  }) async {
    _deviceId = deviceId;

    await _register(
      deviceId: deviceId,
      pushToken: pushToken,
      bundleId: bundleId,
      liveActivityColor: liveActivityColor,
    );

    final validLessons = _filterLessons(todayLessons);
    if (validLessons.isNotEmpty) {
      await _uploadSchedule(deviceId: deviceId, lessons: validLessons);
    }
  }

  /// Token rotation esetén frissíti a tokent a szerveren.
  Future<void> refreshToken({
    required String pushToken,
    required String bundleId,
    required String liveActivityColor,
  }) async {
    if (_deviceId == null) return;
    await _register(
      deviceId: _deviceId!,
      pushToken: pushToken,
      bundleId: bundleId,
      liveActivityColor: liveActivityColor,
    );
  }

  Future<void> _register({
    required String deviceId,
    required String pushToken,
    required String bundleId,
    required String liveActivityColor,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'device_id': deviceId,
          'apns_token': pushToken,
          'bundle_id': bundleId,
          'settings': {
            'live_activity_color': liveActivityColor,
          },
        }),
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint('ServerSync register hiba: ${response.statusCode} ${response.body}');
      } else {
        debugPrint('ServerSync: device regisztrálva');
      }
    } catch (e) {
      debugPrint('ServerSync register kivétel: $e');
    }
  }

  Future<void> _uploadSchedule({
    required String deviceId,
    required List<Lesson> lessons,
  }) async {
    try {
      final now = DateTime.now();
      final dateStr =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final lessonsJson = lessons
          .map((l) => {
                'index': l.lessonIndex.toString(),
                'subject': l.subject.renamedTo ??
                    ShortSubject.resolve(subject: l.subject).capital(),
                'icon': SubjectIcon.resolveName(subject: l.subject),
                'room': l.room.replaceAll('_', ' '),
                'description': l.description,
                'start': l.start.millisecondsSinceEpoch,
                'end': l.end.millisecondsSinceEpoch,
              })
          .toList();

      final response = await http.post(
        Uri.parse('$_baseUrl/schedule'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'device_id': deviceId,
          'date': dateStr,
          'lessons': lessonsJson,
        }),
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint('ServerSync schedule hiba: ${response.statusCode} ${response.body}');
      } else {
        debugPrint('ServerSync: ${lessons.length} óra feltöltve ($dateStr)');
      }
    } catch (e) {
      debugPrint('ServerSync schedule kivétel: $e');
    }
  }

  Future<void> unregister() async {
    if (_deviceId == null) return;
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/unregister'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'device_id': _deviceId}),
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        debugPrint('ServerSync: schedule törölve (unregister)');
      } else {
        debugPrint('ServerSync unregister hiba: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('ServerSync unregister kivétel: $e');
    }
  }

  List<Lesson> _filterLessons(List<Lesson> lessons) {
    return lessons
        .where((l) =>
            l.status?.name != 'Elmaradt' && l.subject.id != '' && !l.isEmpty)
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));
  }
}
