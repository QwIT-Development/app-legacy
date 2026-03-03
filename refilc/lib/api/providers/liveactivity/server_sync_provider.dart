import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:refilc/helpers/subject.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc_kreta_api/models/lesson.dart';

class ServerSyncProvider {
  static const String _baseUrl = 'https://live.firka.app';

  String? _deviceId;

  /// App indításkor hívandó: regisztrálja a device-t és feltölti a mai órarendet.
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
      final client = HttpClient();
      final uri = Uri.parse('$_baseUrl/register');
      final request = await client.postUrl(uri);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode({
        'device_id': deviceId,
        'apns_token': pushToken,
        'bundle_id': bundleId,
        'settings': {
          'live_activity_color': liveActivityColor,
        },
      }));
      final response =
          await request.close().timeout(const Duration(seconds: 10));
      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint('ServerSync register hiba: ${response.statusCode}');
      } else {
        debugPrint('ServerSync: device regisztrálva');
      }
      client.close();
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

      final client = HttpClient();
      final uri = Uri.parse('$_baseUrl/schedule');
      final request = await client.postUrl(uri);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode({
        'device_id': deviceId,
        'date': dateStr,
        'lessons': lessonsJson,
      }));
      final response =
          await request.close().timeout(const Duration(seconds: 10));
      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint('ServerSync schedule hiba: ${response.statusCode}');
      } else {
        debugPrint('ServerSync: ${lessons.length} óra feltöltve ($dateStr)');
      }
      client.close();
    } catch (e) {
      debugPrint('ServerSync schedule kivétel: $e');
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
