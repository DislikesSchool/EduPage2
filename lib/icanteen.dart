import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eduapge2/main.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduapge2/l10n/app_localizations.dart';
import 'package:toastification/toastification.dart';

class ICanteenPage extends StatefulWidget {
  final SessionManager sessionManager;

  const ICanteenPage({
    super.key,
    required this.sessionManager,
  });

  @override
  BaseState<ICanteenPage> createState() => ICanteenPageState();
}

class ICanteenPageState extends BaseState<ICanteenPage> {
  late SessionManager sessionManager;
  late SharedPreferences sharedPreferences;

  bool loading = true;
  ICanteenManager icm = ICanteenManager.getInstance();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();

    await icm.init();

    if (icm.isConfigured()) {
      if (await icm.login()) {
        if (await icm.loadMonth() == 1) {
          await icm.login();
          await icm.loadMonth();
        }
      }
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _pullRefresh() async {
    setState(() {
      loading = true;
    });
    await icm.loadMonth();
    setState(() {
      loading = false;
    });
  }

  Future<void> _changeOrder(String changeURL) async {
    setState(() {
      loading = true;
    });
    await icm.changeOrder(changeURL);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    sessionManager = widget.sessionManager;
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: loading
          ? Text(AppLocalizations.of(context)!.iCanteenLoading)
          : ListView.builder(
              itemCount: icm.data.days.length,
              itemBuilder: (context, index) {
                ICanteenDay lunch = icm.data.days[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          lunch.day,
                        ),
                        for (ICanteenLunch lunchOpt in lunch.lunches)
                          Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  if (lunchOpt.ordered)
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.check),
                                    ),
                                  if (!lunchOpt.canOrder && !lunchOpt.ordered)
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.block),
                                    ),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () async {
                                        await _changeOrder(lunchOpt.changeUrl);
                                      },
                                      child: Text(
                                        lunchOpt.name,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ICanteenManager {
  final Dio dio = Dio();
  late SharedPreferences sharedPreferences;
  String cookies = "";

  // Singleton instance
  static ICanteenManager? _instance;

  ICanteenData data = ICanteenData(days: [], credit: "");
  String baseUrl = FirebaseRemoteConfig.instance.getString("testUrl");

  // Private constructor
  ICanteenManager._privateConstructor() {
    _initDio();
  }

  // Public getter for the singleton instance
  static ICanteenManager getInstance() {
    _instance ??= ICanteenManager._privateConstructor();
    return _instance!;
  }

  void _initDio() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) {
          Sentry.configureScope((scope) {
            scope.setTag("ICanteen Dio error message", error.message ?? "");
            scope.setContexts("ICanteen Dio error response",
                error.response?.data.toString() ?? {});
          });
          toastification.show(
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            title: Text(error.message ?? "Error"),
            description:
                Text(error.response?.data.toString() ?? "An error occurred"),
            alignment: Alignment.bottomCenter,
            autoCloseDuration: const Duration(seconds: 15),
            icon: const Icon(Icons.error),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: highModeShadow,
            showProgressBar: true,
            closeOnClick: false,
            applyBlurEffect: true,
          );
          return handler.next(error);
        },
      ),
    );
  }

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();

    // Try loading from cache
    await loadFromCache();

    // Check if we have credentials
    if (isConfigured()) {
      await loadMonth();
    }
  }

  bool isConfigured() {
    if (sharedPreferences.getString("ic_email") == null ||
        sharedPreferences.getString("ic_password") == null ||
        sharedPreferences.getString("ic_server") == null) {
      return false;
    }
    return true;
  }

  Future<bool> login() async {
    Response response = await dio.post(
      "$baseUrl/icanteen/login",
      data: {
        "username": sharedPreferences.getString("ic_email"),
        "password": sharedPreferences.getString("ic_password"),
        "server": sharedPreferences.getString("ic_server"),
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        validateStatus: (status) {
          return true;
        },
        responseType: ResponseType.plain,
      ),
    );

    if (response.statusCode != 200) {
      return false;
    }

    cookies = response.data;
    return true;
  }

  Future<int> loadMonth() async {
    // First ensure we have valid credentials
    if (!await login()) {
      return 2;
    }

    Response response = await dio.post(
      "$baseUrl/icanteen/month",
      data: {
        "server": sharedPreferences.getString("ic_server"),
        "cookies": cookies,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        validateStatus: (status) {
          return true;
        },
      ),
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 400 &&
          response.data["error"] == "cookies are no longer valid") {
        // Try to login again and retry
        if (await login()) {
          return await loadMonth();
        }
        return 1;
      } else {
        return 2;
      }
    }

    data = ICanteenData.fromJson(response.data);
    await saveToCache();
    return 0;
  }

  Future<void> changeOrder(String changeURL) async {
    Response response = await dio.post(
      "$baseUrl/icanteen/change",
      data: {
        "server": sharedPreferences.getString("ic_server"),
        "cookies": cookies,
        "changeURL": changeURL,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        validateStatus: (status) {
          return true;
        },
      ),
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 400 &&
          response.data["error"] == "cookies are no longer valid") {
        await login();
        await changeOrder(changeURL);
        return;
      }
      return;
    }

    ICanteenData changedData = ICanteenData.fromJson(response.data);

    data.credit = changedData.credit;

    int index = data.days.indexWhere((element) {
      return element.day == changedData.days[0].day;
    });

    if (index != -1) {
      data.days[index] = changedData.days[0];
    }

    await saveToCache();
  }

  // Save data to cache
  Future<void> saveToCache() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('icanteen_data', jsonEncode(data.toJson()));
  }

  // Load data from cache
  Future<void> loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('icanteen_data');
    if (cachedData != null) {
      try {
        data = ICanteenData.fromJson(jsonDecode(cachedData));
      } catch (e) {
        // If parsing fails, keep default empty data
      }
    }
  }
}

class ICanteenLunch {
  final String name;
  final bool ordered;
  final bool canOrder;
  final String changeUrl;

  ICanteenLunch({
    required this.name,
    required this.ordered,
    required this.canOrder,
    required this.changeUrl,
  });

  factory ICanteenLunch.fromJson(Map<String, dynamic> json) {
    return ICanteenLunch(
      name: json['name'] as String,
      ordered: json['ordered'] as bool,
      canOrder: json['can_order'] as bool,
      changeUrl: json['change_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ordered': ordered,
      'can_order': canOrder,
      'change_url': changeUrl,
    };
  }
}

class ICanteenDay {
  final String day;
  final List<ICanteenLunch> lunches;

  ICanteenDay({
    required this.day,
    required this.lunches,
  });

  factory ICanteenDay.fromJson(Map<String, dynamic> json) {
    return ICanteenDay(
      day: json['day'] as String,
      lunches: (json['lunches'] as List<dynamic>)
          .map((item) => ICanteenLunch.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'lunches': lunches.map((lunch) => lunch.toJson()).toList(),
    };
  }
}

class ICanteenData {
  List<ICanteenDay> days;
  String credit;

  ICanteenData({
    required this.days,
    required this.credit,
  });

  factory ICanteenData.fromJson(Map<String, dynamic> json) {
    return ICanteenData(
      days: (json['days'] as List<dynamic>)
          .map((day) => ICanteenDay.fromJson(day as Map<String, dynamic>))
          .toList(),
      credit: json['credit'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'days': days.map((day) => day.toJson()).toList(),
      'credit': credit,
    };
  }
}
