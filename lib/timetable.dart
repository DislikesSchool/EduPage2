import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeTablePage extends StatefulWidget {
  final SessionManager sessionManager;

  const TimeTablePage({super.key, required this.sessionManager});

  @override
  State<TimeTablePage> createState() => TimeTablePageState();
}

class TimeTablePageState extends State<TimeTablePage> {
  String baseUrl = FirebaseRemoteConfig.instance.getString("testUrl");

  TimeTableData tt = TimeTableData(DateTime.now(), <TimeTableClass>[
    TimeTableClass("1", "1", "THIS", "Yeah", "8:55", "9:40", "U32", 0, {}),
    TimeTableClass("2", "2", "IS", "I don't", "10:00", "10:45", "U02", 0, {}),
    TimeTableClass("3", "3", "NOT", "Know", "10:55", "11:40", "U60", 0, {}),
    TimeTableClass("4", "4", "WORKING", "Why", "11:50", "12:35", "U60", 1, {})
  ], [
    TimeTablePeriod("1", "8:00", "8:55", "1", "1")
  ]);

  Dio dio = Dio();

  bool error = false; //for error status
  bool loading = false; //for data featching status
  String errmsg = ""; //to assing any error message from API/runtime
  late Map<String, dynamic> apidataTT;
  List<TimeTablePeriod> periods = [];
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

    SharedPreferences sp = await SharedPreferences.getInstance();
    String? endpoint = sp.getString("customEndpoint");

    if (endpoint != null && endpoint != "") {
      baseUrl = endpoint;
    }
    setState(() {});

    apidataTT = await widget.sessionManager.get('timetable');
    List<dynamic> periodData = await widget.sessionManager.get('periods');

    for (Map<String, dynamic> period in periodData) {
      periods.add(TimeTablePeriod(period["id"], period["starttime"],
          period["endtime"], period["name"], period["short"]));
    }

    List<TimeTableClass> ttClasses = <TimeTableClass>[];
    Map<String, dynamic> classes = apidataTT["Days"];
    for (List<dynamic> ttClass in classes.values) {
      ttClasses = [];
      for (Map<String, dynamic> ttLesson in ttClass) {
        if (ttLesson["studentids"] != null) {
          ttClasses.add(
            TimeTableClass(
              ttLesson["uniperiod"],
              ttLesson["uniperiod"],
              ttLesson["subject"]["short"],
              ttLesson["teachers"].length > 0
                  ? ttLesson["teachers"][0]["short"]
                  : "?",
              ttLesson["starttime"],
              ttLesson["endtime"],
              ttLesson["classrooms"].length > 0
                  ? ttLesson["classrooms"][0]["short"]
                  : "?",
              0,
              ttLesson,
            ),
          );
        }
      }
      TimeTableData t = processTimeTable(TimeTableData(
          DateTime.parse(ttClass.first["date"]), ttClasses, periods));
      timetables.add(t);
    }

    loading = false;
    refresh = false;
    setState(() {}); //refresh UI

    if (sp.getBool('quickstart') ?? false) {
      await loadTt(DateTime.now());
      setState(() {});
    }
  }

  Future<TimeTableData> loadTt(DateTime date) async {
    if (timetables.any((element) => isSameDay(element.date, date))) {
      return timetables.firstWhere((element) => isSameDay(element.date, date));
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token")!;

    Response response = await dio.get(
      "$baseUrl/api/timetable?to=${DateFormat('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'', 'en_US').format(DateTime(date.year, date.month, date.day))}&from=${DateFormat('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'', 'en_US').format(DateTime(date.year, date.month, date.day))}",
      options: buildCacheOptions(
        const Duration(days: 4),
        forceRefresh: true,
        maxStale: const Duration(days: 14),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      ),
    );

    List<TimeTableClass> ttClasses = <TimeTableClass>[];
    Map<String, dynamic> lessons = response.data["Days"];
    for (Map<String, dynamic> ttLesson
        in lessons.values.isEmpty ? [] : lessons.values.first) {
      if (ttLesson["studentids"] != null) {
        ttClasses.add(
          TimeTableClass(
            ttLesson["uniperiod"],
            ttLesson["uniperiod"],
            ttLesson["subject"]["short"],
            ttLesson["teachers"].length > 0
                ? ttLesson["teachers"][0]["short"]
                : "?",
            ttLesson["starttime"],
            ttLesson["endtime"],
            ttLesson["classrooms"].length > 0
                ? ttLesson["classrooms"][0]["short"]
                : "?",
            0,
            ttLesson,
          ),
        );
      }
    }
    TimeTableData t = processTimeTable(TimeTableData(
        DateTime.parse(response.data["Days"].keys.isEmpty
            ? date.toString()
            : response.data["Days"].keys.first),
        ttClasses,
        periods));
    timetables.add(t);
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: loading
          ? const CircularProgressIndicator()
          : PageView.builder(
              controller: PageController(initialPage: 500),
              itemBuilder: (context, index) {
                return getTimeTable(
                    timetables.firstWhere(
                      (element) => isSameDay(
                        element.date,
                        DateTime.now().add(
                          Duration(days: daydiff + index - 500),
                        ),
                      ),
                      orElse: () {
                        loadTt(
                          DateTime.now().add(
                            Duration(days: daydiff + index - 500),
                          ),
                        ).then(
                          (value) => {
                            tt = value,
                            setState(
                              () {},
                            ),
                          },
                        );
                        return tt;
                      },
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
                              Duration(days: daydiff + index - 500),
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
                    true,
                    context);
              },
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

TimeTableData processTimeTable(TimeTableData tt) {
  List<TimeTableClass> classes = tt.classes;
  List<TimeTablePeriod> periods = tt.periods;

  // Match class end times to period end times
  for (int i = 0; i < classes.length; i++) {
    TimeTableClass currentClass = classes[i];
    TimeTablePeriod currentPeriod = periods.firstWhere(
        (period) => period.id == currentClass.endPeriod,
        orElse: () => TimeTablePeriod(
            currentClass.startPeriod,
            currentClass.startPeriod,
            currentClass.endPeriod,
            currentClass.startPeriod,
            currentClass.startPeriod));
    if (currentClass.endTime != currentPeriod.endTime) {
      int nextPeriodIndex = periods
          .indexWhere((period) => period.endTime == currentClass.endTime);
      if (nextPeriodIndex != -1) {
        TimeTablePeriod nextPeriod = periods[nextPeriodIndex];
        currentClass.endPeriod = nextPeriod.id;
      }
    }
  }

  classes.sort((a, b) {
    int? sp = int.tryParse(a.startPeriod);
    int? ep = int.tryParse(b.endPeriod);
    if (sp == null || ep == null) return 0;
    return sp.compareTo(ep);
  });
  periods.sort((a, b) => a.startTime.compareTo(b.startTime));

  List<TimeTableClass> newClasses = [];

  // Add empty classes in between existing classes
  for (int i = 0; i < classes.length - 1; i++) {
    TimeTableClass currentClass = classes[i];
    TimeTableClass nextClass = classes[i + 1];
    int currentPeriodIndex =
        periods.indexWhere((period) => period.id == currentClass.endPeriod);
    int nextPeriodIndex =
        periods.indexWhere((period) => period.id == nextClass.startPeriod);
    bool hasClassAfter =
        nextPeriodIndex != -1 && nextPeriodIndex - currentPeriodIndex > 1;
    if (hasClassAfter) {
      for (int j = currentPeriodIndex + 1; j < nextPeriodIndex; j++) {
        TimeTablePeriod emptyPeriod = periods[j];
        TimeTableClass emptyClass = TimeTableClass(
          emptyPeriod.id,
          emptyPeriod.id,
          "",
          "",
          emptyPeriod.startTime,
          emptyPeriod.endTime,
          "",
          0,
          {},
        );
        newClasses.add(emptyClass);
      }
    }
  }

  classes.addAll(newClasses);
  classes.sort(
      (a, b) => int.parse(a.startPeriod).compareTo(int.parse(b.startPeriod)));

  return TimeTableData(tt.date, classes, periods);
}

class TimeTableData {
  TimeTableData(this.date, this.classes, this.periods);

  final DateTime date;
  final List<TimeTableClass> classes;
  final List<TimeTablePeriod> periods;
}

class TimeTablePeriod {
  final String id;
  final String startTime;
  final String endTime;
  final String name;
  final String short;

  TimeTablePeriod(this.id, this.startTime, this.endTime, this.name, this.short);
}

class TimeTableClass {
  TimeTableClass(
      this.startPeriod,
      this.endPeriod,
      this.subject,
      this.teacher,
      this.startTime,
      this.endTime,
      this.classRoom,
      this.notifications,
      this.data);

  final String startPeriod;
  String endPeriod;
  final String subject;
  final String teacher;
  final String startTime;
  final String endTime;
  final String classRoom;
  final int notifications;
  final dynamic data;
}

Widget getTimeTable(TimeTableData tt, int daydiff, Function(int) modifyDayDiff,
    AppLocalizations? local, bool userInteracted, BuildContext context) {
  List<TableRow> rows = <TableRow>[];

  for (TimeTableClass ttclass in tt.classes) {
    List<Widget> extrasRow = <Widget>[];
    if (ttclass.data["teachers"] != null &&
        ttclass.data["teachers"].length > 0) {
      List<dynamic> teachers = ttclass.data["teachers"];
      String names = teachers.length == 1 ? "Teacher: " : "Teachers: ";
      names += teachers[0]["firstname"] + " " + teachers[0]["lastname"];
      for (Map<String, dynamic> teacher in teachers.skip(1)) {
        names += ", ${teacher["firstname"]} ${teacher["lastname"]}";
      }
      extrasRow.add(
        Expanded(
          child: Text(
            names,
            overflow: TextOverflow.fade,
            maxLines: 5,
            softWrap: false,
          ),
        ),
      );
    }
    if (ttclass.data['curriculum'] != null) {
      extrasRow.add(
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
      extrasRow.add(
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
    List<Widget> cRows = [];
    int? sp = int.tryParse(ttclass.startPeriod);
    int? ep = int.tryParse(ttclass.endPeriod);
    if (sp == null || ep == null) continue;
    for (int i = sp; i <= ep; i++) {
      TimeTablePeriod period = tt.periods.firstWhere((e) => e.short == "$i",
          orElse: () => TimeTablePeriod(
              ttclass.startPeriod,
              ttclass.startPeriod,
              ttclass.endPeriod,
              ttclass.startPeriod,
              ttclass.startPeriod));
      cRows.add(
        Row(
          children: [
            Text(
              "${period.short}.  ",
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
              "${period.startTime} - ${period.endTime}",
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
            /* Not implemented yet
            Badge(
              label: Text(ttclass.notifications.toString()),
              isLabelVisible: ttclass.notifications != 0,
              child: const Icon(Icons.inbox),
            )
            */
          ],
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
                    ...cRows,
                    Row(
                      children: extrasRow,
                    ),
                  ],
                )),
          ),
        ),
      ],
    ));
  }

  String getPrefix(DateTime date, Locale local, AppLocalizations? loc) {
    DateTime now = DateTime.now();
    DateTime today = DateTime.utc(now.year, now.month, now.day);
    DateTime tomorrow = today.add(const Duration(days: 1));
    if (date == today) {
      return loc!.today;
    } else if (date == tomorrow) {
      return loc!.tomorrow;
    } else {
      return '';
    }
  }

  Widget renderDate(DateTime date, Locale local, AppLocalizations? loc) {
    String prefix = getPrefix(date, local, loc);
    String weekday = DateFormat('EEEE', local.toString()).format(date);
    String day = DateFormat('d', local.toString()).format(date);
    String month = DateFormat('MMMM', local.toString()).format(date);

    if (prefix.isNotEmpty) {
      return Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              prefix.toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            '$weekday, $day $month',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
        ],
      );
    } else {
      return Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              weekday.toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            '$day $month',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
        ],
      );
    }
  }

  return Card(
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    modifyDayDiff(-1);
                  },
                  icon: const Icon(Icons.keyboard_arrow_left)),
              const Spacer(),
              renderDate(tt.date, Localizations.localeOf(context), local),
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
