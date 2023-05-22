import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeTablePage extends StatefulWidget {
  final SessionManager sessionManager;

  const TimeTablePage({super.key, required this.sessionManager});

  @override
  State<TimeTablePage> createState() => TimeTablePageState();
}

class TimeTablePageState extends State<TimeTablePage> {
  String baseUrl = "https://lobster-app-z6jfk.ondigitalocean.app/api";

  TimeTableData tt = TimeTableData(DateTime.now(), <TimeTableClass>[
    TimeTableClass("2", "ZAE", "STJI", "8:55", "9:40", "U32", 0, {}),
    TimeTableClass("3", "ANJ", "MAOL", "10:00", "10:45", "U02", 0, {}),
    TimeTableClass("4", "CJL", "GAMA", "10:55", "11:40", "U60", 0, {}),
    TimeTableClass("5", "MAT", "VAPE", "11:50", "12:35", "U60", 1, {})
  ]);

  late Response response;
  Dio dio = Dio();

  bool error = false; //for error status
  bool loading = false; //for data featching status
  String errmsg = ""; //to assing any error message from API/runtime
  late Map<String, dynamic> apidataTT;
  bool refresh = false;
  bool userInteracted = false;

  int daydiff = 0;

  List<TimeTableData> timetables = [];

  @override
  void initState() {
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);
    getData(); //fetching data
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  DateTime getWeekDay() {
    DateTime now = DateTime.now();
    if (now.weekday > 5) {
      now.add(Duration(days: 8 - now.weekday));
    }
    return DateTime(now.year, now.month, now.day);
  }

  getData() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });

    apidataTT = await widget.sessionManager.get('timetable');

    List<TimeTableClass> ttClasses = <TimeTableClass>[];
    List<dynamic> lessons = apidataTT["lessons"];
    for (Map<String, dynamic> ttLesson in lessons) {
      ttClasses.add(
        TimeTableClass(
          ttLesson["period"]["name"],
          ttLesson["subject"]["short"],
          ttLesson["teachers"][0]["short"],
          ttLesson["period"]["startTime"],
          ttLesson["period"]["endTime"],
          ttLesson["classrooms"][0]["short"],
          0,
          ttLesson,
        ),
      );
    }
    tt = TimeTableData(DateTime.parse(apidataTT["date"]), ttClasses);
    timetables.add(tt);

    loading = false;
    refresh = false;
    setState(() {}); //refresh UI
  }

  Future<TimeTableData> loadTt(DateTime date) async {
    if (timetables.any((element) => isSameDay(element.date, date))) {
      return timetables.firstWhere((element) => isSameDay(element.date, date));
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token")!;

    Response response = await dio.get(
      "$baseUrl/timetable/${DateTime(date.year, date.month, date.day).toString()}",
      options: buildCacheOptions(
        Duration.zero,
        maxStale: const Duration(days: 7),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      ),
    );

    List<TimeTableClass> ttClasses = <TimeTableClass>[];
    List<dynamic> lessons = jsonDecode(response.data)["lessons"];
    for (Map<String, dynamic> ttLesson in lessons) {
      ttClasses.add(
        TimeTableClass(
          ttLesson["period"]["name"],
          ttLesson["subject"]["short"],
          ttLesson["teachers"][0]["short"],
          ttLesson["period"]["startTime"],
          ttLesson["period"]["endTime"],
          ttLesson["classrooms"].length > 0
              ? ttLesson["classrooms"][0]["short"]
              : "?",
          0,
          ttLesson,
        ),
      );
    }
    TimeTableData t = TimeTableData(
        DateTime.parse(jsonDecode(response.data)["date"]), ttClasses);
    timetables.add(t);
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Stack(
        children: <Widget>[
          getTimeTable(
            timetables.firstWhere(
              (element) => isSameDay(
                element.date,
                DateTime.now().add(
                  Duration(days: daydiff),
                ),
              ),
              orElse: () => tt,
            ),
            daydiff,
            (diff) => {
              setState(
                () {
                  daydiff = daydiff + diff;
                  userInteracted = true;
                },
              ),
              loadTt(
                DateTime.now().add(
                  Duration(days: daydiff),
                ),
              ).then(
                (value) => {
                  tt = value,
                  setState(
                    () {},
                  ),
                },
              ),
            },
            AppLocalizations.of(context),
            userInteracted,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}

bool isSameDay(DateTime day1, DateTime day2) {
  return day1.day == day2.day &&
      day1.month == day2.month &&
      day1.year == day2.year;
}

class TimeTableData {
  TimeTableData(this.date, this.classes);

  final DateTime date;
  final List<TimeTableClass> classes;
}

class TimeTableClass {
  TimeTableClass(this.period, this.subject, this.teacher, this.startTime,
      this.endTime, this.classRoom, this.notifications, this.data);

  final String period;
  final String subject;
  final String teacher;
  final String startTime;
  final String endTime;
  final String classRoom;
  final int notifications;
  final dynamic data;
}

String getLabel(DateTime date, AppLocalizations? local) {
  DateTime now = DateTime.now();
  DateTime tmr = now.add(const Duration(days: 1));
  if (date.day == now.day && date.month == now.month && date.year == now.year) {
    return "${local!.today}: ${[
      local.monday,
      local.tuesday,
      local.wednesday,
      local.thursday,
      local.friday,
      local.saturday,
      local.sunday
    ][now.weekday - 1]} ${now.day}.${now.month}.${now.year}";
  } else if (date.day == tmr.day &&
      date.month == tmr.month &&
      date.year == tmr.year) {
    return "${local!.tomorrow}: ${[
      local.monday,
      local.tuesday,
      local.wednesday,
      local.thursday,
      local.friday,
      local.saturday,
      local.sunday
    ][tmr.weekday - 1]} ${tmr.day}.${tmr.month}.${tmr.year}";
  } else {
    return "${[
      local?.monday,
      local?.tuesday,
      local?.wednesday,
      local?.thursday,
      local?.friday,
      local?.saturday,
      local?.sunday
    ][date.weekday - 1]} ${date.day}.${date.month}.${date.year}";
  }
}

Widget getTimeTable(TimeTableData tt, int daydiff, Function(int) modifyDayDiff,
    AppLocalizations? local, bool userInteracted) {
  List<TableRow> rows = <TableRow>[];
  if (daydiff == 0 && tt.classes.isNotEmpty) {
    String endTime = tt.classes.last.endTime;
    DateTime now = DateTime.now();
    DateTime end = DateTime(now.year, now.month, now.day,
        int.parse(endTime.split(':')[0]), int.parse(endTime.split(':')[1]));
    if (end.compareTo(now) < 0 && !userInteracted) {
      modifyDayDiff(1);
    }
  }
  for (TimeTableClass ttclass in tt.classes) {
    Row extrasRow = Row(
      // ignore: prefer_const_literals_to_create_immutables
      children: [],
    );
    if (ttclass.data['curriculum'] != null) {
      extrasRow.children.add(
        Expanded(
          child: Text(
            ttclass.data['curriculum'],
            overflow: TextOverflow.fade,
            maxLines: 5,
            softWrap: false,
          ),
        ),
      );
    }
    if (ttclass.data['homeworkNote'] != null &&
        ttclass.data['homeworkNote'] != "") {
      extrasRow.children.add(
        Expanded(
          child: Text(
            ttclass.data['homeworkNote'],
            overflow: TextOverflow.fade,
            maxLines: 5,
            softWrap: false,
          ),
        ),
      );
    }
    rows.add(TableRow(
      children: [
        TableCell(
          child: Card(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "${ttclass.period}.  ",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          ttclass.subject,
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${ttclass.startTime} - ${ttclass.endTime}",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${ttclass.classRoom}  ",
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Badge(
                          label: Text(ttclass.notifications.toString()),
                          isLabelVisible: ttclass.notifications != 0,
                          child: const Icon(Icons.inbox),
                        )
                      ],
                    ),
                    extrasRow,
                  ],
                )),
          ),
        ),
      ],
    ));
  }
  return Card(
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    modifyDayDiff(-1);
                  },
                  icon: const Icon(Icons.keyboard_arrow_left)),
              const Spacer(),
              Text(
                getLabel(tt.date, local),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    modifyDayDiff(1);
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_right,
                    key: Key("TimeTableScrollForward"),
                  )),
            ],
          ),
          Table(
            children: rows,
          ),
        ],
      ),
    ),
  );
}
