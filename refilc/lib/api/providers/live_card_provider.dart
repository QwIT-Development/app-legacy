// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:refilc/api/providers/liveactivity/platform_channel.dart';
import 'package:refilc/api/providers/liveactivity/server_sync_provider.dart';
import 'package:refilc/helpers/subject.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/ui/flutter_colorpicker/utils.dart';
import 'package:refilc_kreta_api/models/lesson.dart';
import 'package:refilc_kreta_api/models/subject.dart';
import 'package:refilc_kreta_api/models/category.dart' as kreta;
import 'package:refilc_kreta_api/models/teacher.dart';
import 'package:refilc_kreta_api/models/week.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc_kreta_api/providers/timetable_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:refilc_mobile_ui/pages/home/live_card/live_card.i18n.dart';

enum LiveCardState {
  empty,
  duringLesson,
  duringBreak,
  morning,
  weekendMorning,
  afternoon,
  night,
  summary,
}

class LiveCardProvider extends ChangeNotifier {
  Lesson? currentLesson;
  Lesson? nextLesson;
  Lesson? prevLesson;
  List<Lesson>? nextLessons;

  static bool hasActivityStarted = false;
  static bool hasDayEnd = false;
  static bool hasUserDismissed = false;
  static DateTime? storeFirstRunDate;
  static DateTime? _lastProcessedDay;
  static bool hasActivitySettingsChanged = false;
  // ignore: non_constant_identifier_names
  static Map<String, String> LAData = {};
  static DateTime? now;

  LiveCardState currentState = LiveCardState.empty;
  // ignore: unused_field
  late Timer _timer;
  late final TimetableProvider _timetable;
  late final SettingsProvider _settings;
  static final ServerSyncProvider serverSync = ServerSyncProvider();

  late Duration _delay;

  bool _hasCheckedTimetable = false;

  LiveCardProvider({
    required TimetableProvider timetable,
    required SettingsProvider settings,
  })  : _timetable = timetable,
        _settings = settings {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => update());
    _delay = settings.bellDelayEnabled
        ? Duration(seconds: settings.bellDelay)
        : Duration.zero;

    PlatformChannel.onTokenUpdated = (pushToken, deviceId, bundleId) {
      if (!_settings.liveActivityEnabled) return;
      debugPrint("Push token érkezett: $pushToken");
      serverSync.registerAndSync(
        deviceId: deviceId,
        pushToken: pushToken,
        bundleId: bundleId,
        liveActivityColor:
            '#${settings.liveActivityColor.toHexString().substring(2)}',
        todayLessons: _today(_timetable),
      );
    };

    PlatformChannel.onActivityDismissed = (deviceId) {
      debugPrint("Live Activity dismissed by user");
      serverSync.forceUnregister(deviceId);
      hasActivityStarted = false;
      hasUserDismissed = true;
    };

    update();
  }

  static DateTime _now() {
    return DateTime.now();
  }

  String getFloorDifference() {
    final prevFloor = prevLesson!.getFloor();
    final nextFloor = nextLesson!.getFloor();
    if (prevFloor == null || nextFloor == null || prevFloor == nextFloor) {
      return "to room";
    }
    if (nextFloor == 0) {
      return "ground floor";
    }
    if (nextFloor > prevFloor) {
      return "up floor";
    } else {
      return "down floor";
    }
  }

  Map<String, String> toMap() {
    String color = '#${_settings.liveActivityColor.toHexString().substring(2)}';

    switch (currentState) {
      case LiveCardState.morning:
        return {
          "color": color,
          "icon": nextLesson != null
              ? SubjectIcon.resolveName(subject: nextLesson?.subject)
              : "book",
          "title": "Jó reggelt! Az első órádig:",
          "subtitle": "",
          "description": "",
          "startDate": storeFirstRunDate != null
              ? ((storeFirstRunDate?.millisecondsSinceEpoch ?? 0) -
                      (_delay.inMilliseconds))
                  .toString()
              : "",
          "endDate": ((nextLesson?.start.millisecondsSinceEpoch ?? 0) -
                  _delay.inMilliseconds)
              .toString(),
          "nextSubject": nextLesson != null
              ? nextLesson?.subject.renamedTo ??
                  ShortSubject.resolve(subject: nextLesson?.subject).capital()
              : "",
          "nextRoom": nextLesson?.room.replaceAll("_", " ") ?? "",
        };

      case LiveCardState.afternoon:
        return {
          "color": color,
          "icon": nextLesson != null
              ? SubjectIcon.resolveName(subject: nextLesson?.subject)
              : "book",
          "title": "Jó napot! Az első órádig:",
          "subtitle": "",
          "description": "",
          "startDate": storeFirstRunDate != null
              ? ((storeFirstRunDate?.millisecondsSinceEpoch ?? 0) -
                      (_delay.inMilliseconds))
                  .toString()
              : "",
          "endDate": ((nextLesson?.start.millisecondsSinceEpoch ?? 0) -
                  _delay.inMilliseconds)
              .toString(),
          "nextSubject": nextLesson != null
              ? nextLesson?.subject.renamedTo ??
                  ShortSubject.resolve(subject: nextLesson?.subject).capital()
              : "",
          "nextRoom": nextLesson?.room.replaceAll("_", " ") ?? "",
        };

      case LiveCardState.night:
        return {
          "color": color,
          "icon": nextLesson != null
              ? SubjectIcon.resolveName(subject: nextLesson?.subject)
              : "book",
          "title": "Jó estét! Az első órádig:",
          "subtitle": "",
          "description": "",
          "startDate": storeFirstRunDate != null
              ? ((storeFirstRunDate?.millisecondsSinceEpoch ?? 0) -
                      (_delay.inMilliseconds))
                  .toString()
              : "",
          "endDate": ((nextLesson?.start.millisecondsSinceEpoch ?? 0) -
                  _delay.inMilliseconds)
              .toString(),
          "nextSubject": nextLesson != null
              ? nextLesson?.subject.renamedTo ??
                  ShortSubject.resolve(subject: nextLesson?.subject).capital()
              : "",
          "nextRoom": nextLesson?.room.replaceAll("_", " ") ?? "",
        };

      case LiveCardState.duringLesson:
        return {
          "color": color,
          "icon": currentLesson != null
              ? SubjectIcon.resolveName(subject: currentLesson?.subject)
              : "book",
          "index":
              currentLesson != null ? '${currentLesson!.lessonIndex}. ' : "",
          "title": currentLesson != null
              ? currentLesson?.subject.renamedTo ??
                  ShortSubject.resolve(subject: currentLesson?.subject)
                      .capital()
              : "",
          "subtitle":
              "Terem: ${currentLesson?.room.replaceAll("_", " ") ?? ""}",
          "description": currentLesson?.description ?? "",
          "startDate": ((currentLesson?.start.millisecondsSinceEpoch ?? 0) -
                  _delay.inMilliseconds)
              .toString(),
          "endDate": ((currentLesson?.end.millisecondsSinceEpoch ?? 0) -
                  _delay.inMilliseconds)
              .toString(),
          "nextSubject": nextLesson != null
              ? nextLesson?.subject.renamedTo ??
                  ShortSubject.resolve(subject: nextLesson?.subject).capital()
              : "",
          "nextRoom": nextLesson?.room.replaceAll("_", " ") ?? "",
        };
      case LiveCardState.duringBreak:
        final iconFloorMap = {
          "to room": "chevron.right.2",
          "up floor": "arrow.up.right",
          "down floor": "arrow.down.left",
          "ground floor": "arrow.down.left",
        };

        final diff = getFloorDifference();

        return {
          "color": color,
          "icon": iconFloorMap[diff] ?? "cup.and.saucer",
          "title": "Szünet",
          "description": "go $diff".i18n.fill([
            diff != "to room" ? (nextLesson!.getFloor() ?? 0) : nextLesson!.room
          ]),
          "startDate": ((prevLesson?.end.millisecondsSinceEpoch ?? 0) -
                  _delay.inMilliseconds)
              .toString(),
          "endDate": ((nextLesson?.start.millisecondsSinceEpoch ?? 0) -
                  _delay.inMilliseconds)
              .toString(),
          "nextSubject": (nextLesson != null
                  ? nextLesson?.subject.renamedTo ??
                      ShortSubject.resolve(subject: nextLesson?.subject)
                          .capital()
                  : "")
              .capital(),
          "nextRoom": nextLesson?.room.replaceAll("_", " ") ?? "",
          "index": "",
          "subtitle": "",
        };
      default:
        return {};
    }
  }

  void update() async {
    List<Lesson> today = _today(_timetable);

    if (today.isEmpty && !_hasCheckedTimetable) {
      _hasCheckedTimetable = true;
      await _timetable.fetch(week: Week.current());
      today = _today(_timetable);
    }

    _delay = _settings.bellDelayEnabled
        ? Duration(seconds: _settings.bellDelay)
        : Duration.zero;

    DateTime now = _now().add(_delay);
    _resetDayScopedState(now);

    currentLesson = null;
    nextLesson = null;
    prevLesson = null;
    nextLessons = null;

    if ((currentState == LiveCardState.morning ||
            currentState == LiveCardState.afternoon ||
            currentState == LiveCardState.night) &&
        storeFirstRunDate == null) {
      storeFirstRunDate = now;
    }

    today = today
        .where((lesson) =>
            lesson.status?.name != "Elmaradt" &&
            lesson.subject.id != '' &&
            !lesson.isEmpty)
        .toList();

    if (today.isNotEmpty) {
      today.sort((a, b) => a.start.compareTo(b.start));

      final _lesson = today.firstWhere(
          (l) => l.start.isBefore(now) && l.end.isAfter(now),
          orElse: () => Lesson.fromJson({}));

      if (_lesson.start.year != 0) {
        currentLesson = _lesson;
      } else {
        currentLesson = null;
      }

      final _next = today.firstWhere((l) => l.start.isAfter(now),
          orElse: () => Lesson.fromJson({}));
      nextLessons = today.where((l) => l.start.isAfter(now)).toList();

      if (_next.start.year != 0) {
        nextLesson = _next;
      } else {
        nextLesson = null;
      }

      final _prev = today.lastWhere((l) => l.end.isBefore(now),
          orElse: () => Lesson.fromJson({}));

      if (_prev.start.year != 0) {
        prevLesson = _prev;
      } else {
        prevLesson = null;
      }
    }

    if (now.isBefore(DateTime(now.year, DateTime.august, 31)) &&
        now.isAfter(DateTime(now.year, DateTime.june, 14)) &&
        !(_settings.developerMode && _settings.devLiveFakeLessons)) {
      currentState = LiveCardState.summary;
    } else if (currentLesson != null) {
      currentState = LiveCardState.duringLesson;
    } else if (nextLesson != null && prevLesson != null) {
      currentState = LiveCardState.duringBreak;
    } else if (now.hour >= 12 && now.hour < 20) {
      currentState = LiveCardState.afternoon;
    } else if (now.hour >= 20) {
      currentState = LiveCardState.night;
    } else if (now.hour >= 5 && now.hour <= 10) {
      if (nextLesson == null ||
          ((now.weekday == 6 || now.weekday == 7) &&
              !(_settings.developerMode && _settings.devLiveFakeLessons))) {
        currentState = LiveCardState.empty;
      } else {
        currentState = LiveCardState.morning;
      }
    } else {
      currentState = LiveCardState.empty;
    }

    if (!_settings.liveActivityEnabled) {
      if (hasActivityStarted) {
        debugPrint("Live Activity nincs engedélyezve, de fut – leállítás...");
        PlatformChannel.endLiveActivity();
        serverSync.unregister();
        hasActivityStarted = false;
      }
    } else {
      if (!hasActivityStarted &&
          !hasUserDismissed &&
          nextLesson != null &&
          nextLesson!.start.difference(now).inMinutes <= 120 &&
          (currentState == LiveCardState.morning ||
              currentState == LiveCardState.afternoon ||
              currentState == LiveCardState.night)) {
        debugPrint(
            "Az első óra előtt állunk, kevesebb mint két órával. Létrehozás...");
        hasActivityStarted = true;
        _createAndSync();
      } else if (!hasActivityStarted &&
          !hasUserDismissed &&
          ((currentState == LiveCardState.duringLesson &&
                  currentLesson != null) ||
              currentState == LiveCardState.duringBreak)) {
        debugPrint(
            "Óra van, vagy szünet, de nincs LiveActivity. létrehozás...");
        hasActivityStarted = true;
        _createAndSync();
      } else if (!hasActivityStarted &&
          _settings.developerMode &&
          _settings.devLiveFakeLessons &&
          today.isNotEmpty) {
        debugPrint("Fake mód: Live Activity létrehozás...");
        hasActivityStarted = true;
        hasUserDismissed = false;
        _createAndSync();
      } else if (hasActivityStarted) {
        if (hasActivitySettingsChanged) {
          debugPrint("Valamelyik beállítás megváltozott. Frissítés...");
          PlatformChannel.updateLiveActivity(toMap());
          hasActivitySettingsChanged = false;
        } else if (nextLesson != null || currentLesson != null) {
          bool afterPrevLessonEnd = prevLesson != null &&
              now
                  .subtract(const Duration(seconds: 1))
                  .isBefore(prevLesson!.end) &&
              now.isAfter(prevLesson!.end);

          bool afterCurrentLessonStart = currentLesson != null &&
              now
                  .subtract(const Duration(seconds: 1))
                  .isBefore(currentLesson!.start) &&
              now.isAfter(currentLesson!.start);
          if (afterPrevLessonEnd || afterCurrentLessonStart) {
            debugPrint(
                "Óra kezdete/vége után 1 másodperccel vagyunk. Frissítés...");
            PlatformChannel.updateLiveActivity(toMap());
          }
        }
      }

      if (_settings.developerMode && _settings.devLiveFakeLessons) {
      } else if ((currentState == LiveCardState.afternoon ||
              currentState == LiveCardState.morning ||
              currentState == LiveCardState.night) &&
          hasActivityStarted &&
          nextLesson != null &&
          nextLesson!.start.difference(now).inMinutes > 60) {
        debugPrint("Több, mint 1 óra van az első óráig. Befejezés...");
        PlatformChannel.endLiveActivity();
        serverSync.unregister();
        hasActivityStarted = false;
      } else if (hasActivityStarted &&
          !hasDayEnd &&
          nextLesson == null &&
          prevLesson != null &&
          now.isAfter(prevLesson!.end) &&
          today.every((l) => l.end.isBefore(now))) {
        debugPrint("Az utolsó óra véget ért. Befejezés...");
        PlatformChannel.endLiveActivity();
        serverSync.unregister();
        hasDayEnd = true;
        hasActivityStarted = false;
        hasUserDismissed = false;
      } else if (hasActivityStarted && currentState == LiveCardState.empty) {
        debugPrint("Nincs több megjeleníthető mai állapot. Befejezés...");
        PlatformChannel.endLiveActivity();
        serverSync.unregister();
        hasActivityStarted = false;
      }
    } // end of liveActivityEnabled else block

    LAData = toMap();
    notifyListeners();
  }

  Future<void> _createAndSync() async {
    final result = await PlatformChannel.createLiveActivity(toMap());
    if (result != null && result['success'] == 'true') {
      debugPrint("Live Activity létrehozva, várunk a push tokenre...");
    } else {
      debugPrint("Live Activity létrehozás sikertelen");
      hasActivityStarted = false;
    }
  }

  bool get show => currentState != LiveCardState.empty;
  Duration get delay => _delay;

  bool _sameDate(DateTime a, DateTime b) =>
      (a.year == b.year && a.month == b.month && a.day == b.day);

  void _resetDayScopedState(DateTime now) {
    if (_lastProcessedDay != null && _sameDate(_lastProcessedDay!, now)) {
      return;
    }

    if (hasActivityStarted) {
      PlatformChannel.endLiveActivity();
      serverSync.unregister();
    }

    _lastProcessedDay = DateTime(now.year, now.month, now.day);
    hasActivityStarted = false;
    hasDayEnd = false;
    hasUserDismissed = false;
    storeFirstRunDate = null;
  }

  List<Lesson> _today(TimetableProvider p) {
    final real = (p.getWeek(Week.current()) ?? [])
        .where((l) => _sameDate(l.date, _now()))
        .toList();
    if (!_settings.developerMode || !_settings.devLiveFakeLessons) {
      return real;
    }
    if (real.isNotEmpty) {
      final sorted = List<Lesson>.from(real)
        ..sort((a, b) => a.end.compareTo(b.end));
      final lastEnd = sorted.last.end;
      final now = _now();
      final nextIndex = sorted.length;
      if (lastEnd.isBefore(now)) {
        return [...real, ..._generateFakeLessons(startIndex: nextIndex)];
      }

      final fakeStart = lastEnd.add(const Duration(minutes: 10));
      return [
        ...real,
        ..._generateFakeLessons(baseStart: fakeStart, startIndex: nextIndex)
      ];
    }
    return _generateFakeLessons();
  }

  static List<Lesson> _generateFakeLessons(
      {DateTime? baseStart, int startIndex = 0}) {
    final now = _now();
    final start0 = baseStart ?? now.subtract(const Duration(minutes: 10));

    const subjects = [
      ('Matematika', 'fake_math', 'Egyenletek'),
      ('Magyar', 'fake_hun', 'Nyelvtan'),
      ('Angol', 'fake_eng', 'Writing'),
      ('Fizika', 'fake_phys', 'Mechanika'),
      ('Történelem', 'fake_hist', 'XX. század'),
      ('Informatika', 'fake_info', 'Programozás'),
    ];

    final lessons = <Lesson>[];
    for (int i = 0; i < 6; i++) {
      final start = start0.add(Duration(minutes: i * 55));
      final end = start.add(const Duration(minutes: 45));
      final (name, id, desc) = subjects[i];
      lessons.add(Lesson(
        id: 'fake_lesson_${startIndex + i}',
        date: DateTime(now.year, now.month, now.day),
        subject: GradeSubject(
          id: id,
          category: kreta.Category(id: '', name: ''),
          name: name,
        ),
        lessonIndex: '${startIndex + i + 1}',
        teacher: Teacher(id: 'fake_teacher', name: 'Teszt Tanár'),
        start: start,
        end: end,
        homeworkId: '',
        description: desc,
        room: '${(i + 1) * 100 + 1}',
        groupName: '',
        name: name,
      ));
    }
    return lessons;
  }
}
