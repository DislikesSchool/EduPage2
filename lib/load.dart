import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:eduapge2/login.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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
    loadUser();
  }

  Future<Map<String, dynamic>> login(
      String email, String password, String? server) async {
    server ??= "";
    try {
      Response resp = await dio.post("$baseUrl/login",
          data: {"username": email, "password": password, "server": server},
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return {"fail": false, "resp": resp};
    } catch (e) {
      return {"fail": true, "err": e};
    }
  }

  Future<Map<String, dynamic>> validate(String token) async {
    try {
      Response resp = await dio.get("$baseUrl/validate-token",
          options: Options(headers: {"Authorization": "Bearer $token"}));
      return {"faul": false, "resp": resp};
    } catch (e) {
      return {"fail": true, "err": e};
    }
  }

  Future<void> loadUser() async {
    String? token = sharedPreferences.getString("token");
    String? email = sharedPreferences.getString("email");
    String? password = sharedPreferences.getString("password");
    String? server = sharedPreferences.getString("server");

    if (token != null && token != "") {
      loaderText = local!.loadVerify;
      progress = 0.3;
      setState(() {});
      bool isExpired;
      try {
        isExpired = JwtDecoder.isExpired(token);
      } catch (e) {
        isExpired = true;
      }
      if (isExpired) {
        sharedPreferences.remove("token");
        startedInit = false;
        init();
      } else {
        Response? res;
        await validate(token).then((resp) => {
              if (resp["fail"] == true)
                {
                  sharedPreferences.remove("token"),
                  startedInit = false,
                  init(),
                }
              else
                {
                  res = resp["resp"],
                }
            });
        if (res != null) {
          if (res?.statusCode == 200) {
            sessionManager.set('user', jsonEncode(res?.data));
            loaderText = local!.loadLoggedIn;
            progress = 0.4;
            setState(() {});
            return loadTimeTable();
          } else if (res?.statusCode == 401) {
            sharedPreferences.remove("token");
            startedInit = false;
            init();
          }
        }
      }
    } else if (email != null && password != null) {
      loaderText = local!.loadLoggingIn;
      progress = 0.2;
      setState(() {});
      Response? res;
      await login(email, password, server).then((resp) => {
            if (resp["fail"] == true)
              {
                sharedPreferences.remove("password"),
                gotoLogin(),
              }
            else
              {
                res = resp["resp"],
              }
          });
      if (res != null) {
        if (res?.statusCode == 200) {
          sessionManager.set('user', jsonEncode(res?.data));
          loaderText = local!.loadLoggedIn;
          progress = 0.4;
          setState(() {});
          sharedPreferences.setString("token", res?.data["token"]);
          return loadTimeTable();
        } else if (res?.statusCode == 400) {
          sharedPreferences.remove("email");
          sharedPreferences.remove("passowrd");
          gotoLogin(res?.data["error"]);
        } else if (res?.statusCode == 401) {
          sharedPreferences.remove("password");
          gotoLogin(res?.data["error"]);
        } else if (res?.statusCode == 500) {
          gotoLogin(res?.data["error"]);
        }
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

  Future<void> loadTimeTable() async {
    progress = 0.7;
    loaderText = local!.loadDownloadTimetable;
    setState(() {});
    String token = sharedPreferences.getString("token")!;
    Response response = await dio.get(
      "$baseUrl/api/timetable/recent",
      options: buildCacheOptions(
        const Duration(days: 3),
        maxStale: const Duration(days: 14),
        forceRefresh: true,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      ),
    );
    sessionManager.set("timetable", jsonEncode(response.data));
    response = await dio.get(
      "$baseUrl/api/periods",
      options: buildCacheOptions(
        const Duration(days: 30),
        forceRefresh: true,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      ),
    );
    sessionManager.set("periods", jsonEncode(response.data.values.toList()));
    return loadMessages();
  }

  Future<void> loadMessages() async {
    progress = 0.9;
    loaderText = local!.loadDownloadMessages;
    setState(() {});
    String token = sharedPreferences.getString("token")!;
    Response response = await dio.get(
      "$baseUrl/api/timeline/recent",
      options: buildCacheOptions(
        const Duration(days: 5),
        maxStale: const Duration(days: 14),
        forceRefresh: !quickstart,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      ),
    );
    sessionManager.set("messages", jsonEncode(response.data["Items"]));
    sessionManager.set("homework", jsonEncode(response.data["Homeworks"]));
    progress = 1.0;
    loaderText = local!.loadDone;
    setState(() {});
    widget.loadedCallback();
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
