import 'package:eduapge2/api.dart';
import 'package:eduapge2/components/timer_display.dart';
import 'package:eduapge2/grades.dart';
import 'package:eduapge2/homework.dart';
import 'package:eduapge2/icanteen.dart';
import 'package:eduapge2/icanteen_setup.dart';
import 'package:eduapge2/main.dart';
import 'package:eduapge2/message.dart';
import 'package:eduapge2/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduapge2/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomePage extends StatefulWidget {
  final SessionManager sessionManager;
  final Function reLogin;
  final ValueChanged<int> onDestinationSelected;

  const HomePage(
      {super.key,
      required this.sessionManager,
      required this.reLogin,
      required this.onDestinationSelected});

  @override
  BaseState<HomePage> createState() => HomePageState();
}

class LessonStatus {
  final bool hasLessonsToday;
  final bool hasLesson;
  final DateTime nextLessonTime;

  LessonStatus({
    required this.hasLessonsToday,
    required this.hasLesson,
    required this.nextLessonTime,
  });
}

extension TimeOfDayExtension on TimeOfDay {
  bool operator <(TimeOfDay other) {
    if (hour < other.hour) {
      return true;
    } else if (hour == other.hour && minute < other.minute) {
      return true;
    } else {
      return false;
    }
  }

  bool operator <=(TimeOfDay other) {
    if (hour < other.hour) {
      return true;
    } else if (hour == other.hour && minute <= other.minute) {
      return true;
    } else {
      return false;
    }
  }

  bool operator >(TimeOfDay other) {
    if (hour > other.hour) {
      return true;
    } else if (hour == other.hour && minute > other.minute) {
      return true;
    } else {
      return false;
    }
  }

  static TimeOfDay fromString(String timeString) {
    List<String> split = timeString.split(':');
    return TimeOfDay(hour: int.parse(split[0]), minute: int.parse(split[1]));
  }
}

extension DateTimeExtension on DateTime {
  static DateTime parseTime(String timeString, {DateTime? date}) {
    final time = TimeOfDay(
      hour: int.parse(timeString.split(':')[0]),
      minute: int.parse(timeString.split(':')[1]),
    );
    final dateTime = date ?? DateTime.now();
    return DateTime(
        dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute);
  }
}

LessonStatus getLessonStatus(
    List<TimeTableClass> lessons, TimeOfDay currentTime) {
  // Check if the user has any lessons today
  final hasLessonsToday = lessons.isNotEmpty;

  // Check if the user has a lesson
  final hasLesson = hasLessonsToday &&
      lessons.any((lesson) {
        final startTime = TimeOfDay.fromDateTime(
            DateTimeExtension.parseTime(lesson.startTime));
        final endTime =
            TimeOfDay.fromDateTime(DateTimeExtension.parseTime(lesson.endTime));
        return startTime < endTime &&
            startTime <= currentTime &&
            endTime > currentTime;
      });

  // Calculate the end time of the current lesson or the start time of the next lesson
  DateTime nextLessonTime;
  try {
    if (hasLesson) {
      final currentLesson = lessons.firstWhere((lesson) {
        final startTime = TimeOfDay.fromDateTime(
            DateTimeExtension.parseTime(lesson.startTime));
        final endTime =
            TimeOfDay.fromDateTime(DateTimeExtension.parseTime(lesson.endTime));
        return startTime < endTime &&
            startTime <= currentTime &&
            endTime > currentTime;
      });
      nextLessonTime = DateTimeExtension.parseTime(currentLesson.endTime);
    } else if (hasLessonsToday) {
      final nextLesson = lessons.firstWhere((lesson) {
        final startTime = TimeOfDay.fromDateTime(
            DateTimeExtension.parseTime(lesson.startTime));
        return startTime > currentTime;
      });
      nextLessonTime = DateTimeExtension.parseTime(nextLesson.startTime);
    } else {
      nextLessonTime = DateTime.now();
    }

    return LessonStatus(
      hasLessonsToday: hasLessonsToday,
      hasLesson: hasLesson,
      nextLessonTime: nextLessonTime,
    );
  } catch (e) {
    return LessonStatus(
        hasLessonsToday: false,
        hasLesson: false,
        nextLessonTime: DateTime.now());
  }
}

class HomePageState extends BaseState<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  SharedPreferences? sharedPreferences;

  bool quickstart = false;

  List<TimelineItem> apidataMsg = [];
  String username = "";
  TimeTableData t = TimeTableData(DateTime.now(), [], []);

  @override
  void initState() {
    super.initState();
    getData();
  }

  DateTime getWeekDay() {
    DateTime now = DateTime.now();
    if (now.weekday > 5) {
      now.add(Duration(days: 8 - now.weekday));
    }
    return DateTime(now.year, now.month, now.day);
  }

  getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    quickstart = sharedPreferences?.getBool('quickstart') ?? false;
    apidataMsg = EP2Data.getInstance().timeline.items.values.toList();
    username = EP2Data.getInstance().user.name;

    t = await EP2Data.getInstance().timetable.today();

    apidataMsg.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    setState(() {}); //refresh UI
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    ThemeData theme = Theme.of(context);

    int lunch = -1;
    DateTime orderLunchesFor = DateTime(1998, 4, 10);

    // Get the iCanteen data from the manager
    ICanteenData iCanteenData = ICanteenManager.getInstance().data;

    if (iCanteenData.days.isNotEmpty) {
      // Check for today's lunch
      DateTime today = DateTime.now();
      for (ICanteenDay day in iCanteenData.days) {
        // Parse the date from the day string
        // (Assuming day format is like "2023-04-10" or contains the date)
        DateTime dayDate;
        try {
          // Try to parse the whole string first
          dayDate = DateTime.parse(day.day);
        } catch (e) {
          // If that fails, try to extract the date portion
          // This is a fallback and might need adjustment based on your actual date format
          RegExp dateRegex = RegExp(r'\d{4}-\d{2}-\d{2}');
          Match? match = dateRegex.firstMatch(day.day);
          if (match != null) {
            dayDate = DateTime.parse(match.group(0)!);
          } else {
            // Skip this day if we can't parse the date
            continue;
          }
        }

        // Check if this is today
        if (dayDate.day == today.day &&
            dayDate.month == today.month &&
            dayDate.year == today.year) {
          lunch = 0; // Default to 0 if no lunch is ordered

          // Check which lunch is ordered today
          for (int i = 0; i < day.lunches.length; i++) {
            if (day.lunches[i].ordered) {
              lunch = i + 1;
              break;
            }
          }
        }

        // Find the next day where user can order but hasn't yet
        bool canOrder = day.lunches.any((lunch) => lunch.canOrder);
        bool hasOrdered = day.lunches.any((lunch) => lunch.ordered);

        if (canOrder && !hasOrdered) {
          orderLunchesFor = DateTime(dayDate.year, dayDate.month, dayDate.day);
          break;
        }
      }
    }
    List<TimelineItem> msgs =
        apidataMsg.where((msg) => msg.type == "sprava").toList();
    List<TimelineItem> msgsWOR = List.from(msgs);
    List<Map<String, int>> bump = [];
    for (TimelineItem msg in msgs) {
      if (msg.reactionTo != "") {
        if (!bump.any((element) =>
            element["id"]!.compareTo(int.parse(msg.reactionTo)) == 0)) {
          bump.add(
              {"id": int.parse(msg.reactionTo), "index": msgsWOR.indexOf(msg)});
          msgsWOR.remove(msg);
        } else {
          msgsWOR.remove(msg);
        }
      }
    }
    for (Map<String, int> b in bump) {
      if (!msgsWOR.any((element) => element.id == b["ineid"].toString())) {
        continue;
      }
      msgsWOR.move(
          msgsWOR.indexOf(msgsWOR
              .firstWhere((element) => int.parse(element.id) == b["id"])),
          b["index"]!);
    }

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  border: Border.all(
                    color: theme.colorScheme.surface,
                  ),
                  borderRadius: BorderRadiusDirectional.circular(25),
                ),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        username,
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 7,
                      top: 7,
                      child: TimerDisplay(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => {
                          scaffoldKey.currentState?.openDrawer(),
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (t.classes.isNotEmpty)
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          elevation: 5,
                          child: SizedBox(
                            height: 110,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                for (TimeTableClass ttclass in t.classes)
                                  GestureDetector(
                                    onTap: () {
                                      widget.onDestinationSelected(1);
                                    },
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                for (int i = int.tryParse(
                                                            ttclass.startPeriod!
                                                                .id) ??
                                                        0;
                                                    i <=
                                                        (int.tryParse(ttclass
                                                                .endPeriod!
                                                                .id) ??
                                                            0);
                                                    i++)
                                                  Text(
                                                    "$i${i != int.tryParse(ttclass.endPeriod!.id) ? " - " : ""}",
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey),
                                                  ),
                                              ],
                                            ),
                                            if (ttclass.subject != null)
                                              Text(
                                                ttclass.subject!.short,
                                                style: const TextStyle(
                                                    fontSize: 22),
                                              ),
                                            for (Classroom classroom
                                                in ttclass.classrooms)
                                              Text(
                                                classroom.short,
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            const SizedBox(height: 2),
                                            Text(
                                              "${ttclass.startTime} - ${ttclass.endTime}",
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: _buildAttendanceCard(context, local, apidataMsg),
              ),
              if (lunch != -1)
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          lunch == -1
                              ? Text(
                                  local!.homeLunchesNotLoaded,
                                  style: const TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                )
                              : lunch == 0
                                  ? Text(
                                      local!.homeNoLunchToday,
                                      style: const TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      local!.homeLunchToday(lunch),
                                      style: const TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                          if (orderLunchesFor != DateTime(1998, 4, 10))
                            Text(local.homeLunchDontForget(orderLunchesFor)),
                        ],
                      ),
                    ),
                  ),
                ),
              if (msgsWOR != [])
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (TimelineItem m in msgsWOR.length < 5
                              ? msgsWOR.reversed
                              : msgsWOR
                                  .getRange(msgsWOR.length - 5, msgsWOR.length)
                                  .toList()
                                  .reversed)
                            InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Card(
                                      elevation: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${m.ownerName.trim()}: ${m.text}'
                                              .replaceAll(RegExp(r'\s+'), ' '),
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MessagePage(
                                      sessionManager: widget.sessionManager,
                                      id: int.parse(m.id),
                                      date: m.timestamp,
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GradesPage(
                              sessionManager: widget.sessionManager,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(Icons.assignment_rounded),
                              AutoSizeText(
                                local!.homeGrades,
                                style: const TextStyle(fontSize: 20),
                                maxLines: 1,
                                minFontSize: 12,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeworkPage(
                              sessionManager: widget.sessionManager,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(Icons.home_work_rounded),
                              AutoSizeText(
                                local.homeHomework,
                                style: const TextStyle(fontSize: 20),
                                maxLines: 1,
                                minFontSize: 12,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.surface,
      drawer: Drawer(
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: ListTile(
                leading: const Icon(Icons.lunch_dining_rounded),
                title: Text(local.homeSetupICanteen),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ICanteenSetupScreen(
                        sessionManager: widget.sessionManager,
                        loadedCallback: () {
                          widget.reLogin();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: ListTile(
                leading: const Icon(Icons.bolt_rounded),
                title: Text(local.homeQuickstart),
                trailing: Transform.scale(
                  scale: 0.75,
                  child: Switch(
                    value: quickstart,
                    onChanged: (bool value) {
                      sharedPreferences?.setBool('quickstart', value);
                      setState(() {
                        quickstart = value;
                      });
                    },
                  ),
                ),
                onTap: () {
                  sharedPreferences?.setBool('quickstart', !quickstart);
                  setState(() {
                    quickstart = !quickstart;
                  });
                },
              ),
            ),
            const Divider(),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: ListTile(
                leading: const Icon(Icons.login_rounded),
                title: Text(local.homeOnboarding),
                onTap: () {
                  sharedPreferences?.setBool('onboardingCompleted', false);
                  widget.reLogin();
                },
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: Text(local.homeLogout),
                onTap: () {
                  sharedPreferences?.remove('email');
                  sharedPreferences?.remove('password');
                  sharedPreferences?.remove('token');
                  sharedPreferences?.clear();
                  EP2Data.getInstance().clearCache();
                  widget.reLogin();
                },
              ),
            ),
            const Divider(),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: ListTile(
                leading: const Icon(Icons.discord),
                title: const Text("EduPage2 Discord"),
                onTap: () async {
                  final url = Uri.parse('https://discord.gg/xy5nqWa2kQ');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: ListTile(
                leading: const Icon(Icons.code),
                title: const Text("EduPage2 GitHub"),
                onTap: () async {
                  final url =
                      Uri.parse('https://github.com/DislikesSchool/EduPage2');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: ListTile(
                leading: const Icon(Icons.coffee),
                title: const Text("Ko-fi"),
                onTap: () async {
                  final url = Uri.parse('https://ko-fi.com/vypal');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ),
            const AboutListTile(
              icon: Icon(Icons.info_outline),
              applicationName: 'EduPage2',
              applicationVersion: String.fromEnvironment('BVS'),
              applicationLegalese: '©2025 Jakub Palacký',
              dense: true,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildAttendanceCard(BuildContext context, AppLocalizations? local,
    List<TimelineItem> apidataMsg) {
  // Get today's and yesterday's date
  final today = DateTime.now();
  final yesterday = today.subtract(const Duration(days: 1));

  // Filter pipnutie items
  final pipnutieItems =
      apidataMsg.where((item) => item.type == 'pipnutie').toList();

  // Attempt to find today's attendance
  List<Map<String, dynamic>> todayAttendance =
      _getAttendanceForDate(pipnutieItems, today);

  // If no arrival for today, try yesterday
  if (todayAttendance.isEmpty ||
      todayAttendance.every((item) => item['type'] != 1)) {
    todayAttendance = _getAttendanceForDate(pipnutieItems, yesterday);
  }

  // Don't show widget if no valid attendance data
  if (todayAttendance.isEmpty ||
      todayAttendance.every((item) => item['type'] != 1)) {
    return const SizedBox.shrink();
  }

  // Get arrival and departure times
  final arrival =
      todayAttendance.firstWhere((item) => item['type'] == 1, orElse: () => {});
  final departure =
      todayAttendance.firstWhere((item) => item['type'] == 2, orElse: () => {});

  // Only proceed if we have at least an arrival time
  if (arrival.isEmpty) {
    return const SizedBox.shrink();
  }

  final arrivalTime = arrival['timestamp'] as DateTime;
  final departureTime =
      departure.isNotEmpty ? departure['timestamp'] as DateTime : null;

  return Card(
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              const Icon(Icons.login, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                "${arrivalTime.hour.toString().padLeft(2, '0')}:${arrivalTime.minute.toString().padLeft(2, '0')}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.logout, color: Colors.red),
              const SizedBox(width: 8),
              departureTime != null
                  ? Text(
                      "${departureTime.hour.toString().padLeft(2, '0')}:${departureTime.minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      "--:--",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ],
          ),
        ],
      ),
    ),
  );
}

List<Map<String, dynamic>> _getAttendanceForDate(
    List<TimelineItem> items, DateTime date) {
  final result = <Map<String, dynamic>>[];

  for (final item in items) {
    try {
      // Check if the item's timestamp is on the specified date
      if (item.timestamp.year == date.year &&
          item.timestamp.month == date.month &&
          item.timestamp.day == date.day) {
        // Extract the attendance type from the nested data structure
        final data = item.data;
        if (data.containsKey('Value') &&
            data['Value'] is Map &&
            data['Value'].containsKey('typ')) {
          final type = int.tryParse(data['Value']['typ'].toString());
          if (type != null && (type == 1 || type == 2)) {
            result.add({
              'type': type, // 1 for arrival, 2 for departure
              'timestamp': item.timestamp,
            });
          }
        }
      }
    } catch (e) {
      // ._.
    }
  }

  // Sort by timestamp
  result.sort((a, b) =>
      (a['timestamp'] as DateTime).compareTo(b['timestamp'] as DateTime));

  return result;
}
