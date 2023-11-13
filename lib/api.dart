import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:eduapge2/timetable.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool> isConnected() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

class EP2Data {
  final Dio dio = Dio();
  late SharedPreferences sharedPreferences;

  String baseUrl = "";
  late User user;
  late Timeline timeline;
  late TimeTable timetable;

  static EP2Data? _instance;

  EP2Data._privateConstructor();

  static EP2Data getInstance() {
    _instance ??= EP2Data._privateConstructor();
    return _instance!;
  }

  Future<bool> init({
    required Function(String, double) onProgressUpdate,
    required AppLocalizations local,
  }) async {
    onProgressUpdate(local.loadCredentials, 0.1);

    sharedPreferences = await SharedPreferences.getInstance();

    bool quickstart = sharedPreferences.getBool("quickstart") ?? false;

    String? endpoint = sharedPreferences.getString("customEndpoint");
    if (endpoint != null && endpoint != "") {
      baseUrl = endpoint;
    } else {
      baseUrl = FirebaseRemoteConfig.instance.getString("testUrl");
    }

    bool isInternetAvailable = await isConnected();

    user = (await User.loadFromCache()) ??
        User(
          username: sharedPreferences.getString("email") ?? "",
          password: sharedPreferences.getString("password") ?? "",
          server: sharedPreferences.getString("server") ?? "",
        );

    if (isInternetAvailable && !quickstart) {
      if (!await user.validate()) {
        onProgressUpdate(local.loadLoggingIn, 0.2);
        if (!await user.login()) {
          return false;
        }
      }
    }
    onProgressUpdate(local.loadLoggedIn, 0.4);

    timeline = (await Timeline.loadFromCache()) ??
        Timeline(
          homeworks: {},
          items: {},
        );

    if (isInternetAvailable && !quickstart) {
      onProgressUpdate(local.loadDownloadMessages, 0.6);
      await timeline.loadMessages();
    }

    timetable = (await TimeTable.loadFromCache()) ?? TimeTable();

    if (isInternetAvailable && !quickstart) {
      onProgressUpdate(local.loadDownloadTimetable, 0.8);
      await timetable.loadRecentTt();
    }

    if (quickstart && isInternetAvailable) {
      loadInBackground();
    }

    return true;
  }

  Future<void> loadInBackground() async {
    if (!await user.validate()) {
      await user.login();
    }
    await timeline.loadMessages();
    await timetable.loadRecentTt();
  }
}

class User {
  final EP2Data data = EP2Data.getInstance();

  final String username;
  final String password;
  String? server = "";

  String token = "";
  String name = "";

  User({
    required this.username,
    required this.password,
    this.server,
  });

  Future<bool> login() async {
    try {
      Response resp = await data.dio.post(
        "${data.baseUrl}/login",
        data: {
          "username": username,
          "password": password,
          "server": server ?? "",
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      token = resp.data['token'];
      name = resp.data["name"];

      saveToCache();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> validate() async {
    try {
      Response resp = await data.dio.get(
        "${data.baseUrl}/validate-token",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (resp.data['success'] != true) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'server': server,
      'token': token,
      'name': name,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
      server: json['server'],
    )
      ..token = json['token']
      ..name = json['name'];
  }

  Future<void> saveToCache() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(toJson());
    await prefs.setString('user', userJson);
  }

  static Future<User?> loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    } else {
      return null;
    }
  }
}

class TimeTable {
  final EP2Data data = EP2Data.getInstance();

  final Map<DateTime, TimeTableData> timetables = {};
  List<TimeTablePeriod>? periods;

  Future<List<TimeTablePeriod>> loadPeriods(String token) async {
    if (periods != null) {
      return periods!;
    }

    Response periodsResponse = await data.dio.get(
      "${data.baseUrl}/api/periods",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    periods = [];
    for (Map<String, dynamic> period in periodsResponse.data.values) {
      periods!.add(TimeTablePeriod(period["id"], period["starttime"],
          period["endtime"], period["name"], period["short"]));
    }

    return periods!;
  }

  Future<TimeTableData> loadTt(DateTime date) async {
    if (timetables.containsKey(date)) {
      return timetables[date]!;
    }

    Response response = await data.dio.get(
      "${data.baseUrl}/api/timetable?to=${DateFormat('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'', 'en_US').format(DateTime(date.year, date.month, date.day))}&from=${DateFormat('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'', 'en_US').format(DateTime(date.year, date.month, date.day))}",
      options: Options(
        headers: {
          "Authorization": "Bearer ${data.user.token}",
        },
      ),
    );

    List<TimeTableClass> ttClasses = <TimeTableClass>[];
    Map<String, dynamic> lessons = response.data["Days"];
    for (Map<String, dynamic> ttLesson
        in lessons.values.isEmpty ? [] : lessons.values.first) {
      if (ttLesson["studentids"] != null) {
        ttClasses.add(TimeTableClass.fromJson(ttLesson));
      }
    }

    periods = await loadPeriods(data.user.token);

    TimeTableData t = processTimeTable(TimeTableData(
        DateTime.parse(response.data["Days"].keys.isEmpty
            ? date.toString()
            : response.data["Days"].keys.first),
        ttClasses,
        periods!));

    DateTime dateOnly = DateTime(date.year, date.month, date.day);
    timetables[dateOnly] = t;
    await saveToCache();
    return t;
  }

  Future<List<TimeTableData>> loadRecentTt() async {
    Response response = await data.dio.get(
      "${data.baseUrl}/api/timetable/recent",
      options: Options(
        headers: {
          "Authorization": "Bearer ${data.user.token}",
        },
      ),
    );

    List<TimeTableData> recentTimetables = [];
    for (MapEntry day in response.data["Days"].entries) {
      List<TimeTableClass> ttClasses = <TimeTableClass>[];
      for (Map<String, dynamic> ttLesson in day.value) {
        if (ttLesson["studentids"] != null) {
          ttClasses.add(TimeTableClass.fromJson(ttLesson));
        }
      }
      periods = await loadPeriods(data.user.token);
      recentTimetables.add(processTimeTable(
          TimeTableData(DateTime.parse(day.key), ttClasses, periods!)));
      timetables[DateTime.parse(day.key)] = recentTimetables.last;
    }

    await saveToCache();
    return recentTimetables;
  }

  // Just a little shortcut
  Future<TimeTableData> today() async {
    return await loadTt(DateTime.now());
  }

  Map<String, dynamic> toJson() => {
        'timetables': timetables.map(
            (key, value) => MapEntry(key.toIso8601String(), value.toJson())),
        'periods': periods?.map((p) => p.toJson()).toList(),
      };

  static TimeTable fromJson(Map<String, dynamic> json) {
    return TimeTable()
      ..timetables.addAll((json['timetables'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          DateTime.parse(key),
          TimeTableData.fromJson(value),
        ),
      ))
      ..periods = (json['periods'] as List)
          .map((p) => TimeTablePeriod.fromJson(p as Map<String, dynamic>))
          .toList();
  }

  Future<void> saveToCache() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('timetable', jsonEncode(toJson()));
  }

  static Future<TimeTable?> loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('timetable')) {
      return null;
    }
    return fromJson(jsonDecode(prefs.getString('timetable')!));
  }
}

class TimeTableData {
  TimeTableData(this.date, this.classes, this.periods);

  final DateTime date;
  final List<TimeTableClass> classes;
  final List<TimeTablePeriod> periods;

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'classes': classes.map((c) => c.toJson()).toList(),
        'periods': periods.map((p) => p.toJson()).toList(),
      };

  static TimeTableData fromJson(Map<String, dynamic> json) =>
      processTimeTable(TimeTableData(
        DateTime.parse(json['date']),
        (json['classes'] as List)
            .map((c) => TimeTableClass.fromJson(c as Map<String, dynamic>))
            .toList(),
        (json['periods'] as List)
            .map((p) => TimeTablePeriod.fromJson(p as Map<String, dynamic>))
            .toList(),
      ));
}

class TimeTablePeriod {
  final String id;
  final String startTime;
  final String endTime;
  final String name;
  final String short;

  TimeTablePeriod(this.id, this.startTime, this.endTime, this.name, this.short);

  Map<String, dynamic> toJson() => {
        'id': id,
        'starttime': startTime,
        'endtime': endTime,
        'name': name,
        'short': short,
      };

  static TimeTablePeriod fromJson(Map<String, dynamic> json) => TimeTablePeriod(
        json['id'],
        json['starttime'],
        json['endtime'],
        json['name'],
        json['short'],
      );
}

class TimeTableClass {
  TimeTableClass({
    this.type = "",
    this.date = "",
    required this.period,
    required this.startTime,
    required this.endTime,
    this.subject,
    this.classes = const [],
    this.groupNames = const [],
    this.iGroupId = "",
    this.teachers = const [],
    this.classrooms = const [],
    this.studentIds = const [],
    this.colors = const [],
  });

  final String type;
  final String date;
  final String period;
  final String startTime;
  final String endTime;
  final Subject? subject;
  final List<Class> classes;
  final List<String> groupNames;
  final String iGroupId;
  final List<Teacher> teachers;
  final List<Classroom> classrooms;
  final List<String> studentIds;
  final List<String> colors;
  TimeTablePeriod? startPeriod;
  TimeTablePeriod? endPeriod;

  Map<String, dynamic> toJson() => {
        'type': type,
        'date': date,
        'uniperiod': period,
        'starttime': startTime,
        'endtime': endTime,
        'subject': subject?.toJson(),
        'classes': classes.map((c) => c.toJson()).toList(),
        'groupnames': groupNames,
        'igroupid': iGroupId,
        'teachers': teachers.map((t) => t.toJson()).toList(),
        'classrooms': classrooms.map((c) => c.toJson()).toList(),
        'studentids': studentIds,
        'colors': colors,
      };

  static TimeTableClass fromJson(Map<String, dynamic> json) => TimeTableClass(
        type: json['type'],
        date: json['date'],
        period: json['uniperiod'],
        startTime: json['starttime'],
        endTime: json['endtime'],
        subject: Subject.fromJson(json['subject'] ??
            {"id": "", "name": "", "short": "", "cbhidden": false}),
        classes: (json['classes'] as List)
            .map((c) => Class.fromJson(c as Map<String, dynamic>))
            .toList(),
        groupNames: List<String>.from(json['groupnames']),
        iGroupId: json['igroupid'],
        teachers: (json['teachers'] as List)
            .map((t) => Teacher.fromJson(t as Map<String, dynamic>))
            .toList(),
        classrooms: (json['classrooms'] as List)
            .map((c) => Classroom.fromJson(c as Map<String, dynamic>))
            .toList(),
        studentIds: List<String>.from(json['studentids']),
        colors: List<String>.from(json['colors'] ?? []),
      );
}

class Teacher {
  Teacher({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.short,
    required this.gender,
    required this.classroomId,
    required this.dateFrom,
    required this.dateTo,
    required this.isOut,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String short;
  final String gender;
  final String classroomId;
  final String dateFrom;
  final String dateTo;
  final bool isOut;

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstName,
        'lastname': lastName,
        'short': short,
        'gender': gender,
        'classroomid': classroomId,
        'datefrom': dateFrom,
        'dateto': dateTo,
        'isout': isOut,
      };

  static Teacher fromJson(Map<String, dynamic> json) => Teacher(
        id: json['id'],
        firstName: json['firstname'],
        lastName: json['lastname'],
        short: json['short'],
        gender: json['gender'],
        classroomId: json['classroomid'],
        dateFrom: json['datefrom'],
        dateTo: json['dateto'],
        isOut: json['isout'],
      );
}

class Class {
  Class({
    required this.id,
    required this.name,
    required this.short,
    required this.grade,
    required this.teacherId,
    required this.teacher2Id,
    required this.classroomId,
  });

  final String id;
  final String name;
  final String short;
  final String grade;
  final String teacherId;
  final String teacher2Id;
  final String classroomId;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'short': short,
        'grade': grade,
        'teacherid': teacherId,
        'teacher2id': teacher2Id,
        'classroomid': classroomId,
      };

  static Class fromJson(Map<String, dynamic> json) => Class(
        id: json['id'],
        name: json['name'],
        short: json['short'],
        grade: json['grade'],
        teacherId: json['teacherid'],
        teacher2Id: json['teacher2id'],
        classroomId: json['classroomid'],
      );
}

class Subject {
  Subject({
    required this.id,
    required this.name,
    required this.short,
    required this.cbHidden,
  });

  final String id;
  final String name;
  final String short;
  final bool cbHidden;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'short': short,
        'cbhidden': cbHidden,
      };

  static Subject fromJson(Map<String, dynamic> json) => Subject(
        id: json['id'],
        name: json['name'],
        short: json['short'],
        cbHidden: json['cbhidden'],
      );
}

class Classroom {
  Classroom({
    required this.id,
    required this.name,
    required this.short,
  });

  final String id;
  final String name;
  final String short;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'short': short,
      };

  static Classroom fromJson(Map<String, dynamic> json) => Classroom(
        id: json['id'],
        name: json['name'],
        short: json['short'],
      );
}

class TimelineItem {
  final String id;
  final DateTime timestamp;
  final String reactionTo;
  final String type;
  final String user;
  final String targetUser;
  final String userName;
  final String otherId;
  final String text;
  final DateTime timeAdded;
  final DateTime timeEvent;
  final Map<String, dynamic> data;
  final String owner;
  final String ownerName;
  final int reactionCount;
  final String lastReaction;
  final String pomocnyZaznam;
  final num removed;
  final DateTime timeAddedBTC;
  final DateTime lastReactionBTC;

  TimelineItem({
    required this.id,
    required this.timestamp,
    required this.reactionTo,
    required this.type,
    required this.user,
    required this.targetUser,
    required this.userName,
    required this.otherId,
    required this.text,
    required this.timeAdded,
    required this.timeEvent,
    required this.data,
    required this.owner,
    required this.ownerName,
    required this.reactionCount,
    required this.lastReaction,
    required this.pomocnyZaznam,
    required this.removed,
    required this.timeAddedBTC,
    required this.lastReactionBTC,
  });

  factory TimelineItem.fromJson(Map<String, dynamic> json) {
    return TimelineItem(
      id: json['timelineid'],
      timestamp: DateTime.parse(json['timestamp']),
      reactionTo: json['reakcia_na'],
      type: json['typ'],
      user: json['user'],
      targetUser: json['target_user'],
      userName: json['user_meno'],
      otherId: json['ineid'],
      text: json['text'],
      timeAdded: DateTime.parse(json['cas_pridania']),
      timeEvent: DateTime.parse(json['cas_udalosti']),
      data: Map<String, dynamic>.from(json['data']),
      owner: json['vlastnik'],
      ownerName: json['vlastnik_meno'],
      reactionCount: json['poct_reakcii'],
      lastReaction: json['posledna_reakcia'],
      pomocnyZaznam: json['pomocny_zaznam'],
      removed: json['removed'],
      timeAddedBTC: DateTime.parse(json['cas_pridania_btc']),
      lastReactionBTC: DateTime.parse(json['cas_udalosti_btc']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timelineid': id,
      'timestamp': timestamp.toIso8601String(),
      'reakcia_na': reactionTo,
      'typ': type,
      'user': user,
      'target_user': targetUser,
      'user_meno': userName,
      'ineid': otherId,
      'text': text,
      'cas_pridania': timeAdded.toIso8601String(),
      'cas_udalosti': timeEvent.toIso8601String(),
      'data': data,
      'vlastnik': owner,
      'vlastnik_meno': ownerName,
      'poct_reakcii': reactionCount,
      'posledna_reakcia': lastReaction,
      'pomocny_zaznam': pomocnyZaznam,
      'removed': removed,
      'cas_pridania_btc': timeAddedBTC.toIso8601String(),
      'cas_udalosti_btc': lastReactionBTC.toIso8601String(),
    };
  }
}

class Homework {
  final String id;
  final String homeworkId;
  final String eSuperId;
  final String userId;
  final num lessonId;
  final String planId;
  final String name;
  final String details;
  final String dateTo;
  final String dateFrom;
  final String datetimeTo;
  final String datetimeFrom;
  final String dateCreated;
  final dynamic period;
  final String timestamp;
  final String testId;
  final String type;
  final num likeCount;
  final num reactionCount;
  final num doneCount;
  final String state;
  final String lastResult;
  final List<String> groups;
  final int eTestCards;
  final int eTestAnswerCards;
  final bool studyTopics;
  final dynamic gradeEventId;
  final String studentsHidden;
  final Map<String, dynamic> data;
  final String evaluationStatus;
  final dynamic ended;
  final bool missingNextLesson;
  final dynamic attachments;
  final String authorName;
  final String lessonName;

  Homework({
    required this.id,
    required this.homeworkId,
    required this.eSuperId,
    required this.userId,
    required this.lessonId,
    required this.planId,
    required this.name,
    required this.details,
    required this.dateTo,
    required this.dateFrom,
    required this.datetimeTo,
    required this.datetimeFrom,
    required this.dateCreated,
    required this.period,
    required this.timestamp,
    required this.testId,
    required this.type,
    required this.likeCount,
    required this.reactionCount,
    required this.doneCount,
    required this.state,
    required this.lastResult,
    required this.groups,
    required this.eTestCards,
    required this.eTestAnswerCards,
    required this.studyTopics,
    required this.gradeEventId,
    required this.studentsHidden,
    required this.data,
    required this.evaluationStatus,
    required this.ended,
    required this.missingNextLesson,
    required this.attachments,
    required this.authorName,
    required this.lessonName,
  });

  factory Homework.fromJson(Map<String, dynamic> json) {
    return Homework(
      id: json['hwkid'],
      homeworkId: json['homeworkid'],
      eSuperId: json['e_superid'],
      userId: json['userid'],
      lessonId: json['predmetid'],
      planId: json['planid'],
      name: json['name'],
      details: json['details'],
      dateTo: json['dateto'],
      dateFrom: json['datefrom'],
      datetimeTo: json['datetimeto'],
      datetimeFrom: json['datetimefrom'],
      dateCreated: json['datecreated'],
      period: json['period'],
      timestamp: json['timestamp'],
      testId: json['testid'],
      type: json['typ'],
      likeCount: json['pocet_like'],
      reactionCount: json['pocet_reakcii'],
      doneCount: json['pocet_done'],
      state: json['stav'],
      lastResult: json['posledny_vysledok'],
      groups: List<String>.from(json['skupiny']),
      eTestCards: json['etestCards'],
      eTestAnswerCards: json['etestAnswerCards'],
      studyTopics: json['studyTopics'],
      gradeEventId: json['znamky_udalostid'],
      studentsHidden: json['students_hidden'],
      data: Map<String, dynamic>.from(json['data']),
      evaluationStatus: json['stavhodnotetimelinePathd'],
      ended: json['skoncil'],
      missingNextLesson: json['missingNextLesson'],
      attachments: json['attachements'],
      authorName: json['autor_meno'],
      lessonName: json['predmet_meno'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hwkid': id,
      'homeworkid': homeworkId,
      'e_superid': eSuperId,
      'userid': userId,
      'predmetid': lessonId,
      'planid': planId,
      'name': name,
      'details': details,
      'dateto': dateTo,
      'datefrom': dateFrom,
      'datetimeto': datetimeTo,
      'datetimefrom': datetimeFrom,
      'datecreated': dateCreated,
      'period': period,
      'timestamp': timestamp,
      'testid': testId,
      'typ': type,
      'pocet_like': likeCount,
      'pocet_reakcii': reactionCount,
      'pocet_done': doneCount,
      'stav': state,
      'posledny_vysledok': lastResult,
      'skupiny': groups,
      'etestCards': eTestCards,
      'etestAnswerCards': eTestAnswerCards,
      'studyTopics': studyTopics,
      'znamky_udalostid': gradeEventId,
      'students_hidden': studentsHidden,
      'data': data,
      'stavhodnotetimelinePathd': evaluationStatus,
      'skoncil': ended,
      'missingNextLesson': missingNextLesson,
      'attachements': attachments,
      'autor_meno': authorName,
      'predmet_meno': lessonName,
    };
  }
}

class Timeline {
  EP2Data data = EP2Data.getInstance();

  Map<String, Homework> homeworks;
  Map<String, TimelineItem> items;

  Timeline({
    required this.homeworks,
    required this.items,
  });

  factory Timeline.fromJson(Map<String, dynamic> json) {
    return Timeline(
      homeworks: (json['Homeworks'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, Homework.fromJson(value)),
      ),
      items: (json['Items'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, TimelineItem.fromJson(value)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Homeworks': homeworks.map((key, value) => MapEntry(key, value.toJson())),
      'Items': items.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  Future<void> saveToCache() async {
    final timelineJson = jsonEncode(toJson());
    await data.sharedPreferences.setString('timeline', timelineJson);
  }

  static Future<Timeline?> loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final timelineJson = prefs.getString('timeline');
    if (timelineJson != null) {
      return Timeline.fromJson(jsonDecode(timelineJson));
    } else {
      return null;
    }
  }

  Future<void> loadMessages() async {
    Response response = await data.dio.get(
      "${data.baseUrl}/api/timeline/recent",
      options: Options(
        headers: {
          "Authorization": "Bearer ${data.user.token}",
        },
      ),
    );

    Map<String, dynamic> newHomeworks = response.data["Homeworks"];
    Map<String, dynamic> newItems = response.data["Items"];

    newHomeworks.forEach((key, value) {
      homeworks[key] = Homework.fromJson(value);
    });

    newItems.forEach((key, value) {
      items[key] = TimelineItem.fromJson(value);
    });

    await saveToCache();
  }

  Future<void> loadOlderMessages() async {
    DateTime oldestTimestamp =
        items.values.fold(DateTime.now(), (oldest, item) {
      DateTime timestamp = item.timestamp;
      return timestamp.isBefore(oldest) ? timestamp : oldest;
    });

    // Calculate from and to dates
    DateTime from = oldestTimestamp.subtract(const Duration(days: 14));
    DateTime to = oldestTimestamp;

    // Add query parameters for from and to dates
    Response response = await data.dio.get(
      "${data.baseUrl}/api/timeline",
      queryParameters: {
        "from": from.toIso8601String(),
        "to": to.toIso8601String(),
      },
      options: Options(
        headers: {
          "Authorization": "Bearer ${data.user.token}",
        },
      ),
    );

    Map<String, dynamic> newHomeworks = response.data["Homeworks"];
    Map<String, dynamic> newItems = response.data["Items"];

    newHomeworks.forEach((key, value) {
      homeworks[key] = Homework.fromJson(value);
    });

    newItems.forEach((key, value) {
      items[key] = TimelineItem.fromJson(value);
    });

    await saveToCache();
  }
}
