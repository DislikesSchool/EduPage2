import 'package:eduapge2/api.dart';
import 'package:eduapge2/main.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeTablePage extends StatefulWidget {
  final SessionManager sessionManager;

  const TimeTablePage({super.key, required this.sessionManager});

  @override
  BaseState<TimeTablePage> createState() => TimeTablePageState();
}

class TimeTablePageState extends BaseState<TimeTablePage> {
  String baseUrl = FirebaseRemoteConfig.instance.getString("testUrl");

  bool error = false; //for error status
  bool loading = false; //for data featching status
  String errmsg = ""; //to assing any error message from API/runtime
  List<TimeTablePeriod> periods = [];
  bool refresh = false;
  bool userInteracted = false;

  EP2Data data = EP2Data.getInstance();

  int daydiff = 0;

  List<TimeTableData> timetables = [];

  @override
  void initState() {
    super.initState();
  }

  DateTime getWeekDay() {
    DateTime now = DateTime.now();
    if (now.weekday > 5) {
      now.add(Duration(days: 8 - now.weekday));
    }
    return DateTime(now.year, now.month, now.day);
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
                    data.timetable.timetables.values.firstWhere(
                      (element) => isSameDay(
                        element.date,
                        DateTime.now().add(
                          Duration(days: daydiff + index - 500),
                        ),
                      ),
                      orElse: () {
                        data.timetable
                            .loadTt(
                              DateTime.now().add(
                                Duration(days: daydiff + index - 500),
                              ),
                            )
                            .then(
                              (value) => {
                                setState(
                                  () {},
                                ),
                              },
                            );
                        return TimeTableData(
                            DateTime.now().add(
                              Duration(days: daydiff + index - 500),
                            ),
                            [],
                            []);
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
                          data.timetable
                              .loadTt(
                                DateTime.now().add(
                                  Duration(days: daydiff + index - 500),
                                ),
                              )
                              .then(
                                (value) => {
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

  // Go through all classes, and assign them a startPeriod and endPeriod both equal to the their period
  for (int i = 0; i < classes.length; i++) {
    TimeTableClass currentClass = classes[i];
    TimeTablePeriod currentPeriod =
        periods.firstWhere((period) => period.id == currentClass.period,
            orElse: () => TimeTablePeriod.fromJson({
                  "id": currentClass.period,
                  "starttime": currentClass.startTime,
                  "endtime": currentClass.endTime,
                  "name": currentClass.period,
                  "short": currentClass.period,
                }));
    currentClass.startPeriod = currentPeriod;
    currentClass.endPeriod = currentPeriod;
  }

  // Match class end times to period end times
  for (int i = 0; i < classes.length; i++) {
    TimeTableClass currentClass = classes[i];
    TimeTablePeriod currentPeriod =
        periods.firstWhere((period) => period.id == currentClass.endPeriod!.id,
            orElse: () => TimeTablePeriod.fromJson({
                  "id": currentClass.endPeriod!.id,
                  "starttime": currentClass.endTime,
                  "endtime": currentClass.endTime,
                  "name": currentClass.endPeriod!.id,
                  "short": currentClass.endPeriod!.id,
                }));
    if (currentClass.endTime != currentPeriod.endTime) {
      int nextPeriodIndex = periods
          .indexWhere((period) => period.endTime == currentClass.endTime);
      if (nextPeriodIndex != -1) {
        TimeTablePeriod nextPeriod = periods[nextPeriodIndex];
        currentClass.endPeriod = nextPeriod;
      }
    }
  }

  classes.sort((a, b) {
    int? sp = int.tryParse(a.startPeriod!.id);
    int? ep = int.tryParse(b.endPeriod!.id);
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
        periods.indexWhere((period) => period.id == currentClass.endPeriod!.id);
    int nextPeriodIndex =
        periods.indexWhere((period) => period.id == nextClass.startPeriod!.id);
    bool hasClassAfter =
        nextPeriodIndex != -1 && nextPeriodIndex - currentPeriodIndex > 1;
    if (hasClassAfter) {
      for (int j = currentPeriodIndex + 1; j < nextPeriodIndex; j++) {
        TimeTablePeriod emptyPeriod = periods[j];
        TimeTableClass emptyClass = TimeTableClass(
          period: emptyPeriod.id,
          startTime: emptyPeriod.startTime,
          endTime: emptyPeriod.endTime,
        );
        emptyClass.startPeriod = emptyPeriod;
        emptyClass.endPeriod = emptyPeriod;
        newClasses.add(emptyClass);
      }
    }
  }

  classes.addAll(newClasses);
  classes.sort((a, b) {
    int? sp = int.tryParse(a.startPeriod!.id);
    int? ep = int.tryParse(b.endPeriod!.id);
    if (sp == null || ep == null) return 0;
    return sp.compareTo(ep);
  });

  return TimeTableData(tt.date, classes, periods);
}

Widget getTimeTable(TimeTableData tt, int daydiff, Function(int) modifyDayDiff,
    AppLocalizations? local, bool userInteracted, BuildContext context) {
  List<TableRow> rows = <TableRow>[];

  for (TimeTableClass ttclass in tt.classes) {
    List<Widget> extrasRow = <Widget>[];
    if (ttclass.teachers.isNotEmpty) {
      List<Teacher> teachers = ttclass.teachers;
      String names = teachers.length == 1 ? "Teacher: " : "Teachers: ";
      names += "${teachers[0].firstName} ${teachers[0].lastName}";
      for (Teacher teacher in teachers.skip(1)) {
        names += ", ${teacher.firstName} ${teacher.lastName}";
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
    /* Not implemented yet
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
    */
    List<Widget> cRows = [];
    int? sp = int.tryParse(ttclass.startPeriod!.id);
    int? ep = int.tryParse(ttclass.endPeriod!.id);
    if (sp == null || ep == null) continue;
    for (int i = sp; i <= ep; i++) {
      TimeTablePeriod period = tt.periods.firstWhere((e) => e.short == "$i",
          orElse: () =>
              TimeTablePeriod("$i", "00:00", "00:00", "Unknown", "Unknown"));
      cRows.add(
        Row(
          children: [
            Text(
              "${period.short}.  ",
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            if (ttclass.subject != null)
              Text(
                ttclass.subject!.short,
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
            for (Classroom classroom in ttclass.classrooms)
              Text(
                "${classroom.short}  ",
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
