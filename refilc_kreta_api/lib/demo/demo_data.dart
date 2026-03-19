import 'package:refilc/models/user.dart';
import 'package:refilc_kreta_api/models/absence.dart';
import 'package:refilc_kreta_api/models/category.dart';
import 'package:refilc_kreta_api/models/exam.dart';
import 'package:refilc_kreta_api/models/grade.dart';
import 'package:refilc_kreta_api/models/group_average.dart';
import 'package:refilc_kreta_api/models/homework.dart';
import 'package:refilc_kreta_api/models/lesson.dart';
import 'package:refilc_kreta_api/models/message.dart';
import 'package:refilc_kreta_api/models/recipient.dart';
import 'package:refilc_kreta_api/models/subject.dart';
import 'package:refilc_kreta_api/models/teacher.dart';
import 'package:refilc_kreta_api/models/week.dart';

class DemoData {
  static final _subjectMath = GradeSubject(
    id: 'demo-subject-math',
    category: Category(id: 'matematika', name: 'matematika'),
    name: 'Matematika',
  );
  static final _subjectHun = GradeSubject(
    id: 'demo-subject-hun',
    category: Category(id: 'magyar_nyelv_es_irodalom', name: 'magyar_nyelv_es_irodalom'),
    name: 'Magyar nyelv és irodalom',
  );
  static final _subjectHist = GradeSubject(
    id: 'demo-subject-hist',
    category: Category(id: 'tortenelem_es_allampolgari_ismeretek', name: 'tortenelem_es_allampolgari_ismeretek'),
    name: 'Történelem',
  );
  static final _subjectEng = GradeSubject(
    id: 'demo-subject-eng',
    category: Category(id: 'angol_nyelv', name: 'angol_nyelv'),
    name: 'Angol nyelv',
  );
  static final _subjectPhy = GradeSubject(
    id: 'demo-subject-phy',
    category: Category(id: 'fizika', name: 'fizika'),
    name: 'Fizika',
  );
  static final _subjectBio = GradeSubject(
    id: 'demo-subject-bio',
    category: Category(id: 'biologia_egeszsegtan', name: 'biologia_egeszsegtan'),
    name: 'Biológia',
  );
  static final _subjectChem = GradeSubject(
    id: 'demo-subject-chem',
    category: Category(id: 'kemia', name: 'kemia'),
    name: 'Kémia',
  );
  static final _subjectPE = GradeSubject(
    id: 'demo-subject-pe',
    category: Category(id: 'testnevelés_és_sport', name: 'testnevelés_és_sport'),
    name: 'Testnevelés',
  );
  static final _subjectIT = GradeSubject(
    id: 'demo-subject-it',
    category: Category(id: 'informatika', name: 'informatika'),
    name: 'Informatika',
  );

  static final _teacherNagy = Teacher.fromString('Nagy Katalin');
  static final _teacherSzabo = Teacher.fromString('Szabó Péter');
  static final _teacherKovacs = Teacher.fromString('Kovács Mária');
  static final _teacherToth = Teacher.fromString('Tóth László');
  static final _teacherVarga = Teacher.fromString('Varga Erzsébet');
  static final _teacherFekete = Teacher.fromString('Fekete Gábor');

  static final _modeOral = Category(id: '1,SzobaliVizsga', name: 'Szóbeli vizsga', description: 'Szóbeli vizsga');
  static final _modeWritten = Category(id: '2,IrasbaliVizsga', name: 'Írásbeli vizsga', description: 'Írásbeli vizsga');
  static final _modePractical = Category(id: '3,Gyakorlati', name: 'Gyakorlati', description: 'Gyakorlati');

  static List<Grade> get grades {
    final now = DateTime.now();
    return [
      _makeGrade('demo-g-1', 5, 'Jeles', 'Ötös', 100, _subjectMath, _teacherNagy, 'Függvények', now.subtract(const Duration(days: 3)), _modeWritten, GradeType.midYear),
      _makeGrade('demo-g-2', 4, 'Jó', 'Négyes', 100, _subjectMath, _teacherNagy, 'Egyenletek', now.subtract(const Duration(days: 14)), _modeWritten, GradeType.midYear),
      _makeGrade('demo-g-3', 5, 'Jeles', 'Ötös', 100, _subjectHun, _teacherKovacs, 'Arany János költészete', now.subtract(const Duration(days: 5)), _modeOral, GradeType.midYear),
      _makeGrade('demo-g-4', 4, 'Jó', 'Négyes', 100, _subjectHun, _teacherKovacs, 'Fogalmazás', now.subtract(const Duration(days: 20)), _modeWritten, GradeType.midYear),
      _makeGrade('demo-g-5', 5, 'Jeles', 'Ötös', 100, _subjectEng, _teacherSzabo, 'Grammar test', now.subtract(const Duration(days: 7)), _modeWritten, GradeType.midYear),
      _makeGrade('demo-g-6', 5, 'Jeles', 'Ötös', 100, _subjectEng, _teacherSzabo, 'Speaking', now.subtract(const Duration(days: 18)), _modeOral, GradeType.midYear),
      _makeGrade('demo-g-7', 4, 'Jó', 'Négyes', 100, _subjectHist, _teacherToth, 'Az első világháború', now.subtract(const Duration(days: 10)), _modeOral, GradeType.midYear),
      _makeGrade('demo-g-8', 3, 'Közepes', 'Hármas', 100, _subjectHist, _teacherToth, 'Témazáró', now.subtract(const Duration(days: 25)), _modeWritten, GradeType.midYear),
      _makeGrade('demo-g-9', 5, 'Jeles', 'Ötös', 100, _subjectPhy, _teacherVarga, 'Mechanika', now.subtract(const Duration(days: 8)), _modeWritten, GradeType.midYear),
      _makeGrade('demo-g-10', 4, 'Jó', 'Négyes', 100, _subjectBio, _teacherFekete, 'Sejtbiológia', now.subtract(const Duration(days: 12)), _modeOral, GradeType.midYear),
      _makeGrade('demo-g-11', 5, 'Jeles', 'Ötös', 100, _subjectChem, _teacherVarga, 'Kémiai kötések', now.subtract(const Duration(days: 6)), _modeWritten, GradeType.midYear),
      _makeGrade('demo-g-12', 5, 'Jeles', 'Ötös', 100, _subjectIT, _teacherSzabo, 'Programozás alapjai', now.subtract(const Duration(days: 4)), _modePractical, GradeType.midYear),
      _makeGrade('demo-g-13', 4, 'Jó', 'Négyes', 100, _subjectMath, _teacherNagy, 'Statisztika', now.subtract(const Duration(days: 30)), _modeWritten, GradeType.halfYear),
      _makeGrade('demo-g-14', 5, 'Jeles', 'Ötös', 100, _subjectHun, _teacherKovacs, 'Félévzáró', now.subtract(const Duration(days: 60)), _modeWritten, GradeType.halfYear),
      _makeGrade('demo-g-15', 4, 'Jó', 'Négyes', 100, _subjectEng, _teacherSzabo, 'Mid-year exam', now.subtract(const Duration(days: 60)), _modeWritten, GradeType.halfYear),
    ];
  }

  static Grade _makeGrade(
    String id,
    int value,
    String valueName,
    String shortName,
    int weight,
    GradeSubject subject,
    Teacher teacher,
    String description,
    DateTime date,
    Category mode,
    GradeType type,
  ) {
    return Grade(
      id: id,
      date: date,
      value: GradeValue(value, valueName, shortName, weight),
      teacher: teacher,
      description: description,
      type: type,
      groupId: 'demo-group',
      subject: subject,
      mode: mode,
      writeDate: date,
      seenDate: date,
      form: '',
      json: {
        'SzamErtek': value,
        'SzovegesErtek': valueName,
        'SzovegesErtekelesRovidNev': shortName,
        'SulySzazalekErteke': weight,
        'ErtekFajta': null,
      },
    );
  }

  static Map<Week, List<Lesson>> get timetable {
    final week = Week.current();
    return {week: _lessonsForWeek(week)};
  }

  static List<Lesson> _lessonsForWeek(Week week) {
    final monday = week.start;
    List<Lesson> lessons = [];

    // Monday
    lessons.addAll(_dayLessons(monday, [
      _LessonDef('Matematika', _subjectMath, _teacherNagy, '101', '9A'),
      _LessonDef('Magyar nyelv és irodalom', _subjectHun, _teacherKovacs, '203', '9A'),
      _LessonDef('Történelem', _subjectHist, _teacherToth, '105', '9A'),
      _LessonDef('Angol nyelv', _subjectEng, _teacherSzabo, '102', '9A'),
      _LessonDef('Testnevelés', _subjectPE, _teacherFekete, 'Tornaterem', '9A'),
    ]));

    // Tuesday
    lessons.addAll(_dayLessons(monday.add(const Duration(days: 1)), [
      _LessonDef('Fizika', _subjectPhy, _teacherVarga, '204', '9A'),
      _LessonDef('Biológia', _subjectBio, _teacherFekete, '205', '9A'),
      _LessonDef('Matematika', _subjectMath, _teacherNagy, '101', '9A'),
      _LessonDef('Informatika', _subjectIT, _teacherSzabo, 'Számítóterem', '9A'),
    ]));

    // Wednesday
    lessons.addAll(_dayLessons(monday.add(const Duration(days: 2)), [
      _LessonDef('Magyar nyelv és irodalom', _subjectHun, _teacherKovacs, '203', '9A'),
      _LessonDef('Kémia', _subjectChem, _teacherVarga, '206', '9A'),
      _LessonDef('Angol nyelv', _subjectEng, _teacherSzabo, '102', '9A'),
      _LessonDef('Történelem', _subjectHist, _teacherToth, '105', '9A'),
      _LessonDef('Testnevelés', _subjectPE, _teacherFekete, 'Tornaterem', '9A'),
    ]));

    // Thursday
    lessons.addAll(_dayLessons(monday.add(const Duration(days: 3)), [
      _LessonDef('Matematika', _subjectMath, _teacherNagy, '101', '9A'),
      _LessonDef('Biológia', _subjectBio, _teacherFekete, '205', '9A'),
      _LessonDef('Fizika', _subjectPhy, _teacherVarga, '204', '9A'),
      _LessonDef('Informatika', _subjectIT, _teacherSzabo, 'Számítóterem', '9A'),
    ]));

    // Friday
    lessons.addAll(_dayLessons(monday.add(const Duration(days: 4)), [
      _LessonDef('Magyar nyelv és irodalom', _subjectHun, _teacherKovacs, '203', '9A'),
      _LessonDef('Kémia', _subjectChem, _teacherVarga, '206', '9A'),
      _LessonDef('Matematika', _subjectMath, _teacherNagy, '101', '9A'),
      _LessonDef('Angol nyelv', _subjectEng, _teacherSzabo, '102', '9A'),
    ]));

    return lessons;
  }

  static List<Lesson> _dayLessons(DateTime day, List<_LessonDef> defs) {
    final List<Lesson> result = [];
    // School starts at 8:00, each lesson is 45 min, 15 min break
    DateTime time = DateTime(day.year, day.month, day.day, 8, 0);
    for (int i = 0; i < defs.length; i++) {
      final def = defs[i];
      final start = time;
      final end = time.add(const Duration(minutes: 45));
      result.add(Lesson(
        id: 'demo-lesson-${day.weekday}-$i',
        date: day,
        subject: def.subject,
        lessonIndex: '${i + 1}',
        teacher: def.teacher,
        start: start,
        end: end,
        homeworkId: '',
        description: '',
        room: def.room,
        groupName: def.group,
        name: def.name,
      ));
      time = end.add(const Duration(minutes: 15));
    }
    return result;
  }

  static List<Absence> get absences {
    final now = DateTime.now();
    return [
      _makeAbsence('demo-abs-1', _subjectMath, _teacherNagy, now.subtract(const Duration(days: 15)), Justification.excused),
      _makeAbsence('demo-abs-2', _subjectMath, _teacherNagy, now.subtract(const Duration(days: 15)), Justification.excused),
      _makeAbsence('demo-abs-3', _subjectHun, _teacherKovacs, now.subtract(const Duration(days: 15)), Justification.excused),
      _makeAbsence('demo-abs-4', _subjectEng, _teacherSzabo, now.subtract(const Duration(days: 8)), Justification.pending),
      _makeAbsence('demo-abs-5', _subjectHist, _teacherToth, now.subtract(const Duration(days: 8)), Justification.pending),
      _makeAbsence('demo-abs-6', _subjectPhy, _teacherVarga, now.subtract(const Duration(days: 2)), Justification.unexcused),
    ];
  }

  static Absence _makeAbsence(
    String id,
    GradeSubject subject,
    Teacher teacher,
    DateTime date,
    Justification state,
  ) {
    final start = DateTime(date.year, date.month, date.day, 8, 0);
    final end = start.add(const Duration(minutes: 45));
    return Absence(
      id: id,
      date: date,
      delay: 0,
      submitDate: date,
      teacher: teacher,
      state: state,
      subject: subject,
      lessonStart: start,
      lessonEnd: end,
      group: 'demo-group',
    );
  }

  static List<Exam> get exams {
    final now = DateTime.now();
    return [
      Exam(
        id: 'demo-exam-1',
        date: now.subtract(const Duration(days: 3)),
        writeDate: now.add(const Duration(days: 7)),
        subject: _subjectMath,
        teacher: _teacherNagy,
        description: 'Trigonometria témazáró',
        group: 'demo-group',
      ),
      Exam(
        id: 'demo-exam-2',
        date: now.subtract(const Duration(days: 5)),
        writeDate: now.add(const Duration(days: 12)),
        subject: _subjectHun,
        teacher: _teacherKovacs,
        description: 'Petőfi Sándor életmű dolgozat',
        group: 'demo-group',
      ),
      Exam(
        id: 'demo-exam-3',
        date: now.subtract(const Duration(days: 1)),
        writeDate: now.add(const Duration(days: 5)),
        subject: _subjectPhy,
        teacher: _teacherVarga,
        description: 'Elektromosságtan',
        group: 'demo-group',
      ),
    ];
  }

  static List<Homework> get homework {
    final now = DateTime.now();
    return [
      Homework(
        id: 'demo-hw-1',
        date: now.subtract(const Duration(days: 2)),
        lessonDate: now.subtract(const Duration(days: 2)),
        deadline: now.add(const Duration(days: 5)),
        byTeacher: true,
        homeworkEnabled: true,
        teacher: _teacherNagy,
        content: 'Oldjátok meg a tankönyv 84-85. oldalán lévő feladatokat (1-15).',
        subject: _subjectMath,
        group: 'demo-group',
        attachments: [],
      ),
      Homework(
        id: 'demo-hw-2',
        date: now.subtract(const Duration(days: 4)),
        lessonDate: now.subtract(const Duration(days: 4)),
        deadline: now.add(const Duration(days: 3)),
        byTeacher: true,
        homeworkEnabled: true,
        teacher: _teacherKovacs,
        content: 'Írjatok egy 1-2 oldalas elemzést Petőfi Sándor "Szeptember végén" c. verséről.',
        subject: _subjectHun,
        group: 'demo-group',
        attachments: [],
      ),
      Homework(
        id: 'demo-hw-3',
        date: now.subtract(const Duration(days: 1)),
        lessonDate: now.subtract(const Duration(days: 1)),
        deadline: now.add(const Duration(days: 6)),
        byTeacher: true,
        homeworkEnabled: true,
        teacher: _teacherSzabo,
        content: 'Complete exercises 3-7 on page 42 of the workbook.',
        subject: _subjectEng,
        group: 'demo-group',
        attachments: [],
      ),
    ];
  }

  static List<Message> get messages {
    final now = DateTime.now();
    return [
      Message(
        id: 10001,
        messageId: 10001,
        seen: true,
        deleted: false,
        date: now.subtract(const Duration(days: 1)),
        author: 'Nagy Katalin',
        content: 'Kedves Szülők!\n\nTájékoztatjuk Önöket, hogy jövő héten pótdolgozatot írunk matematikából. Kérem, segítsenek gyermeküknek a felkészülésben.\n\nÜdvözlettel,\nNagy Katalin',
        subject: 'Pótdolgozat - Matematika',
        type: MessageType.inbox,
        recipients: [Recipient(id: 1, name: 'Demo Diák', kretaId: 1)],
        attachments: [],
        isSeen: true,
      ),
      Message(
        id: 10002,
        messageId: 10002,
        seen: false,
        deleted: false,
        date: now.subtract(const Duration(days: 3)),
        author: 'Kovács Mária',
        content: 'Kedves Diákok!\n\nEmlékeztetem Önöket, hogy a fogalmazást péntekig be kell adni. Kérem, ne felejtsék el!\n\nÜdvözlettel,\nKovács Mária',
        subject: 'Fogalmazás határideje',
        type: MessageType.inbox,
        recipients: [Recipient(id: 1, name: 'Demo Diák', kretaId: 1)],
        attachments: [],
        isSeen: false,
      ),
      Message(
        id: 10003,
        messageId: 10003,
        seen: true,
        deleted: false,
        date: now.subtract(const Duration(days: 7)),
        author: 'Tóth László',
        content: 'Kedves Szülők!\n\nAz osztálykirándulás időpontja: március 20. Kérem, hogy a beleegyező nyilatkozatot hozzák vissza aláírva.\n\nÜdvözlettel,\nTóth László\nosztályfőnök',
        subject: 'Osztálykirándulás',
        type: MessageType.inbox,
        recipients: [Recipient(id: 1, name: 'Demo Diák', kretaId: 1)],
        attachments: [],
        isSeen: true,
      ),
    ];
  }

  static List<GroupAverage> get groupAverages => [
        GroupAverage(uid: 'demo-avg-math', average: 4.2, subject: _subjectMath),
        GroupAverage(uid: 'demo-avg-hun', average: 3.8, subject: _subjectHun),
        GroupAverage(uid: 'demo-avg-hist', average: 3.9, subject: _subjectHist),
        GroupAverage(uid: 'demo-avg-eng', average: 4.5, subject: _subjectEng),
        GroupAverage(uid: 'demo-avg-phy', average: 3.6, subject: _subjectPhy),
        GroupAverage(uid: 'demo-avg-bio', average: 4.1, subject: _subjectBio),
        GroupAverage(uid: 'demo-avg-chem', average: 3.7, subject: _subjectChem),
        GroupAverage(uid: 'demo-avg-pe', average: 4.8, subject: _subjectPE),
        GroupAverage(uid: 'demo-avg-it', average: 4.3, subject: _subjectIT),
      ];

  static bool isDemo(String? userId) => userId == demoUserId;
}

class _LessonDef {
  final String name;
  final GradeSubject subject;
  final Teacher teacher;
  final String room;
  final String group;
  const _LessonDef(this.name, this.subject, this.teacher, this.room, this.group);
}
