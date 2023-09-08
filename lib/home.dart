import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:eduapge2/icanteen_setup.dart';
import 'package:eduapge2/message.dart';
import 'package:eduapge2/messages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final SessionManager sessionManager;
  final Function reLogin;

  const HomePage(
      {super.key, required this.sessionManager, required this.reLogin});

  @override
  State<HomePage> createState() => HomePageState();
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

LessonStatus getLessonStatus(List<dynamic> lessons, TimeOfDay currentTime) {
  // Check if the user has any lessons today
  final hasLessonsToday = lessons.isNotEmpty;

  // Check if the user has a lesson
  final hasLesson = hasLessonsToday &&
      lessons.any((lesson) {
        final startTime = TimeOfDay.fromDateTime(
            DateTimeExtension.parseTime(lesson['starttime']));
        final endTime = TimeOfDay.fromDateTime(
            DateTimeExtension.parseTime(lesson['endtime']));
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
            DateTimeExtension.parseTime(lesson['starttime']));
        final endTime = TimeOfDay.fromDateTime(
            DateTimeExtension.parseTime(lesson['endtime']));
        return startTime < endTime &&
            startTime <= currentTime &&
            endTime > currentTime;
      });
      nextLessonTime = DateTimeExtension.parseTime(currentLesson['endtime']);
    } else if (hasLessonsToday) {
      final nextLesson = lessons.firstWhere((lesson) {
        final startTime = TimeOfDay.fromDateTime(
            DateTimeExtension.parseTime(lesson['starttime']));
        return startTime > currentTime;
      });
      nextLessonTime = DateTimeExtension.parseTime(nextLesson['starttime']);
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

final _shorebirdCodePush = ShorebirdCodePush();

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  late SharedPreferences sharedPreferences;
  String baseUrl = "https://lobster-app-z6jfk.ondigitalocean.app/api";
  late Response response;
  Dio dio = Dio();

  bool error = false; //for error status
  bool loading = true; //for data featching status
  String errmsg = ""; //to assing any error message from API/runtime
  dynamic apidata; //for decoded JSON data
  bool refresh = false;
  bool updateAvailable = false;
  bool quickstart = false;
  bool _isCheckingForUpdate = false;

  late Map<String, dynamic> apidataTT;
  List<dynamic> apidataMsg = [];
  late String username;
  late LessonStatus _lessonStatus;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);
    fetchAndCompareBuildName();
    getData(); //fetching data
    if (!_isCheckingForUpdate) _checkForUpdate(); // ik that it's not necessary
  }

  Future<void> _checkForUpdate() async {
    setState(() {
      _isCheckingForUpdate = true;
    });

    // Ask the Shorebird servers if there is a new patch available.
    final isUpdateAvailable =
        await _shorebirdCodePush.isNewPatchAvailableForDownload();

    if (!mounted) return;

    setState(() {
      _isCheckingForUpdate = false;
    });

    if (isUpdateAvailable) {
      _downloadUpdate();
    }
  }

  void _showDownloadingBanner() {
    ScaffoldMessenger.of(context).showMaterialBanner(
      const MaterialBanner(
        content: Text('Downloading patch...'),
        actions: [
          SizedBox(
            height: 14,
            width: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
        ],
      ),
    );
  }

  void _showRestartBanner() {
    ScaffoldMessenger.of(context).showMaterialBanner(
      const MaterialBanner(
        content: Text('A new patch is ready!'),
        actions: [
          TextButton(
            // Restart the app for the new patch to take effect.
            onPressed: Restart.restartApp,
            child: Text('Restart app'),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadUpdate() async {
    _showDownloadingBanner();
    await _shorebirdCodePush.downloadUpdateIfAvailable();
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    _showRestartBanner();
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
      loading = true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    String? endpoint = sharedPreferences.getString("customEndpoint");

    if (endpoint != null && endpoint != "") {
      baseUrl = endpoint;
    }
    quickstart = sharedPreferences.getBool('quickstart') ?? false;
    var msgs = await widget.sessionManager.get('messages');
    if (msgs != Null && msgs != null) {
      setState(() {
        apidataMsg = msgs.values.toList();
      });
    }

    Map<String, dynamic> user = await widget.sessionManager.get('user');
    username = user["firstname"] + " " + user["lastname"];
    String token = sharedPreferences.getString("token")!;

    Response response = await dio.get(
      "$baseUrl/api/timetable?from=${DateFormat('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'', 'en_US').format(DateTime.now())}",
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
    apidataTT = response.data;
    _lessonStatus =
        getLessonStatus(apidataTT["Days"].values.first, TimeOfDay.now());
    if (_lessonStatus.hasLessonsToday) {
      _startTimer();
    }
    setState(() {
      loading = false;
    }); //refresh UI
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _lessonStatus = getLessonStatus(apidataTT["lessons"], TimeOfDay.now());
        if (!_lessonStatus.hasLessonsToday) {
          _timer?.cancel();
        }
      });
    });
  }

  void fetchAndCompareBuildName() async {
    final dio = Dio();

    // Retrieve the package info
    final packageInfo = await PackageInfo.fromPlatform();
    final buildName = packageInfo.version;

    try {
      final response = await dio.get(
          'https://api.github.com/repos/DislikesSchool/EduPage2/releases/latest');
      final responseData = response.data;

      // Extract the tag_name from the response JSON and remove the "v" prefix if present
      final tag = responseData['tag_name'];
      final formattedTag = tag.startsWith('v') ? tag.substring(1) : tag;

      // Compare the tag_name to the app's build name
      if (formattedTag != buildName) {
        setState(() {
          updateAvailable = true;
        });
      }
    } catch (error) {
      // Handle any errors that occur during the request
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    ThemeData theme = Theme.of(context);
    if (loading) {
      return Center(
        child: Text(local!.loading),
      );
    }

    int lunch = -1;
    DateTime orderLunchesFor = DateTime(1998, 4, 10);
    String? l = sharedPreferences.getString("lunches");
    if (l != null) {
      var lunches = jsonDecode(l) as List<dynamic>;
      if (lunches.isNotEmpty) {
        var lunchToday = lunches[0] as Map<String, dynamic>;
        lunch = 0;
        var todayLunches = lunchToday["lunches"];
        for (int i = 0; i < todayLunches.length; i++) {
          if (todayLunches[i]["ordered"]) lunch = i + 1;
        }
        for (Map<String, dynamic> li in lunches) {
          bool canOrder = false;
          bool hasOrdered = false;
          for (Map<String, dynamic> l in li["lunches"]) {
            if (l["can_order"]) {
              canOrder = true;
            }
            if (l["ordered"]) {
              hasOrdered = true;
            }
          }
          if (canOrder && !hasOrdered) {
            orderLunchesFor = DateTime.parse(li["day"]);
            break;
          }
        }
      }
    }
    List<dynamic> msgs =
        apidataMsg.where((msg) => msg["type"] == "sprava").toList();
    List<dynamic> msgsWOR = List.from(msgs);
    List<Map<String, int>> bump = [];
    for (Map<String, dynamic> msg in msgs) {
      if (msg["replyOf"] != null) {
        if (!bump.any((element) =>
            element["id"]!.compareTo(int.parse(msg["replyOf"])) == 0)) {
          bump.add(
              {"id": int.parse(msg["replyOf"]), "index": msgsWOR.indexOf(msg)});
          msgsWOR.remove(msg);
        } else {
          msgsWOR.remove(msg);
        }
      }
    }
    for (Map<String, int> b in bump) {
      msgsWOR.move(
          msgsWOR.indexOf(msgsWOR
              .firstWhere((element) => int.parse(element["id"]) == b["id"])),
          b["index"]!);
    }
    final remainingTime =
        _lessonStatus.nextLessonTime.difference(DateTime.now());
    final minutes =
        remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');
    final remainingTimeString = '$minutes:$seconds';
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  border: Border.all(
                    color: theme.colorScheme.background,
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
                    if (_lessonStatus.hasLessonsToday)
                      Positioned(
                        right: 15,
                        top: 10,
                        child: Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: Color.fromARGB(
                                  255,
                                  _lessonStatus.hasLesson ? 0 : 255,
                                  _lessonStatus.hasLesson ? 255 : 0,
                                  0),
                              size: 8,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              remainingTimeString,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => {
                        scaffoldKey.currentState?.openDrawer(),
                      },
                    ),
                  ],
                ),
              ),
              if (apidataTT["lessons"].length > 0)
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
                            height: 100,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                for (Map<String, dynamic> lesson
                                    in apidataTT["lessons"])
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Text(
                                            lesson["period"]["name"] + ".",
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                          Text(
                                            lesson["subject"]["short"],
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                          Text(
                                            lesson["classrooms"][0]["short"],
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ],
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
              if (updateAvailable)
                GestureDetector(
                  onTap: () async {
                    final url = Uri.parse(
                        'https://github.com/DislikesSchool/EduPage2/releases/latest');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Stack(
                      children: [
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 10, right: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(local!.homeUpdateTitle,
                                    style: const TextStyle(fontSize: 20)),
                                Text(local.homeUpdateDescription,
                                    style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                updateAvailable = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (lunch != -1 && apidataTT["lessons"].length > 0)
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
                          for (Map<String, dynamic> m in msgsWOR.length < 5
                              ? msgsWOR
                              : msgsWOR.getRange(0, 4))
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
                                          '${m["owner"]["firstname"]?.trim()} ${m["owner"]["lastname"]?.trim()}: ${m["text"]}'
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
                                            sessionManager:
                                                widget.sessionManager,
                                            id: int.parse(m["id"]))));
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.background,
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
                title: Text(local!.homeSetupICanteen),
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
              child: Badge(
                label: Text(local.homePreview),
                alignment: AlignmentDirectional.topEnd,
                child: ListTile(
                  leading: const Icon(Icons.bolt_rounded),
                  title: Text(local.homeQuickstart),
                  trailing: Transform.scale(
                    scale: 0.75,
                    child: Switch(
                      value: quickstart,
                      onChanged: (bool value) {
                        sharedPreferences.setBool('quickstart', value);
                        setState(() {
                          quickstart = value;
                        });
                      },
                    ),
                  ),
                  onTap: () {
                    sharedPreferences.setBool('quickstart', !quickstart);
                    setState(() {
                      quickstart = !quickstart;
                    });
                  },
                ),
              ),
            ),
            const Divider(),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: Text(local.homeLogout),
                onTap: () {
                  sharedPreferences.remove('email');
                  sharedPreferences.remove('password');
                  sharedPreferences.remove('token');
                  widget.reLogin();
                },
              ),
            ),
            const AboutListTile(
              icon: Icon(Icons.info_outline),
              applicationName: 'EduPage2',
              applicationVersion: String.fromEnvironment('BVS'),
              applicationLegalese: '©2023 Jakub Palacký',
              dense: true,
            ),
          ],
        ),
      ),
    );
  }
}
