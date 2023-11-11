import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:eduapge2/api.dart';
import 'package:eduapge2/login.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingScreen extends StatefulWidget {
  final Function loadedCallback;

  const LoadingScreen(
      {super.key, required this.sessionManager, required this.loadedCallback});

  final SessionManager sessionManager;

  @override
  State<StatefulWidget> createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  late SessionManager sessionManager;
  late SharedPreferences sharedPreferences;

  bool startedInit = false;

  Dio dio = Dio();
  double progress = 0.0;
  String loaderText = "Loading...";

  String baseUrl = FirebaseRemoteConfig.instance.getString("testUrl");

  late AppLocalizations? local;

  late bool quickstart;

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  Future<void> init() async {
    if (startedInit) return;
    startedInit = true;
    sharedPreferences = await SharedPreferences.getInstance();
    String? endpoint = sharedPreferences.getString("customEndpoint");
    if (endpoint != null && endpoint != "") {
      baseUrl = endpoint;
    }
    quickstart = sharedPreferences.getBool('quickstart') ?? false;
    if (sharedPreferences.getBool("ice") == true) {
      sessionManager.set("iCanteenEnabled", true);
    }
    progress = 0.1;
    loaderText = local!.loadCredentials;
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);
    setState(() {});
    if (sharedPreferences.getString("email") != null &&
        sharedPreferences.getString("password") != null) {
      if (!await EP2Data.getInstance().init(
          onProgressUpdate: (text, prog) {
            setState(() {
              loaderText = text;
              progress = prog;
            });
          },
          local: local!)) {
        gotoLogin();
      } else {
        widget.loadedCallback();
      }
    } else {
      gotoLogin();
    }
  }

  void gotoLogin([String? err]) async {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginPage(err: err ?? "")))
        .then((value) => {
              setState(() {
                startedInit = false;
              })
            });
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
    if (!startedInit) {
      sessionManager = widget.sessionManager;
      local = AppLocalizations.of(context);
      init();
    }
    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
        ),
        const Spacer(),
        const CircularProgressIndicator(),
        Text("\n$loaderText"),
        const Spacer(),
      ],
    );
  }
}
