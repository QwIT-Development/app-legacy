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

      final entries = <Map<String, dynamic>>[];

      for (int i = 0; i < lessons.length; i++) {
        final l = lessons[i];
        entries.add({
          'type': 'lesson',
          'index': l.lessonIndex.toString(),
          'subject': l.subject.renamedTo ??
              ShortSubject.resolve(subject: l.subject).capital(),
          'icon': SubjectIcon.resolveName(subject: l.subject),
          'room': l.room.replaceAll('_', ' '),
          'description': l.description,
          'start': l.start.millisecondsSinceEpoch,
          'end': l.end.millisecondsSinceEpoch,
        });

        if (i < lessons.length - 1) {
          final next = lessons[i + 1];
          if (l.end.isBefore(next.start)) {
            entries.add({
              'type': 'break',
              'start': l.end.millisecondsSinceEpoch,
              'end': next.start.millisecondsSinceEpoch,
              'nextSubject': next.subject.renamedTo ??
                  ShortSubject.resolve(subject: next.subject).capital(),
              'nextIcon': SubjectIcon.resolveName(subject: next.subject),
              'nextRoom': next.room.replaceAll('_', ' '),
              'nextIndex': next.lessonIndex.toString(),
            });
          }
        }
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/schedule'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'device_id': deviceId,
          'date': dateStr,
          'lessons': entries,
        }),
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint('ServerSync schedule hiba: ${response.statusCode} ${response.body}');
      } else {
        debugPrint('ServerSync: ${entries.length} elem feltöltve ($dateStr)');
      }
    } catch (e) {
      debugPrint('ServerSync schedule kivétel: $e');
    }
  }

  Future<void> unregister() async {
    if (_deviceId == null) return;
    await forceUnregister(_deviceId!);
  }

  Future<void> forceUnregister(String deviceId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/unregister'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'device_id': deviceId}),
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        debugPrint('ServerSync: device + schedule törölve (unregister)');
      } else {
        debugPrint('ServerSync unregister hiba: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('ServerSync unregister kivétel: $e');
    }
    _deviceId = null;
  }

  List<Lesson> _filterLessons(List<Lesson> lessons) {
    return lessons
        .where((l) =>
            l.status?.name != 'Elmaradt' && l.subject.id != '' && !l.isEmpty)
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));
  }
}
