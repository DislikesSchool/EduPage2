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

  bool runningInit = false;

  Dio dio = Dio();

  String baseUrl = FirebaseRemoteConfig.instance.getString("testUrl");
  bool loading = true;

  List<Widget> lunches = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) {
          Sentry.configureScope((scope) {
            scope.setTag("Dio error message", error.message ?? "");
            scope.setContexts(
                "Dio error response", error.response?.data.toString() ?? {});
          });
          toastification.show(
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            title: Text(error.message ?? ""),
            description: Text(error.response?.data.toString() ?? ""),
            alignment: Alignment.bottomCenter,
            autoCloseDuration: const Duration(seconds: 15),
            icon: Icon(Icons.error),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: highModeShadow,
            showProgressBar: true,
            closeButtonShowType: CloseButtonShowType.none,
            closeOnClick: false,
            applyBlurEffect: true,
          );
          return handler.next(error);
        },
      ),
    );

    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      loading = true; //make loading true to show progressindicator
      lunches = [];
    });

    Response response = await dio
        .post(
      "$baseUrl/icanteen",
      data: {
        "username": sharedPreferences.getString("ic_email"),
        "password": sharedPreferences.getString("ic_password"),
        "server": sharedPreferences.getString("ic_server"),
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    )
        .catchError((obj) {
      return Response(
        requestOptions: RequestOptions(path: "$baseUrl/icanteen"),
        statusCode: 500,
      );
    });

    if (response.statusCode != 200) {
      lunches.add(
        const Card(
          child: Text("Sorry, but there was an issue accessing iCanteen"),
        ),
      );
    }

    if (response.statusCode == 200 && response.data.length > 0) {
      sharedPreferences.setString("lunches", jsonEncode(response.data));
      for (Map<String, dynamic> lunch in response.data) {
        lunches.add(
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    lunch["day"],
                  ),
                  for (Map<String, dynamic> lunchOpt in lunch["lunches"])
                    Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            if (lunchOpt["ordered"])
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.check),
                              ),
                            if (!lunchOpt["can_order"] && !lunchOpt["ordered"])
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.block),
                              ),
                            Expanded(
                              child: Text(
                                lunchOpt["name"],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      }
    }

    setState(() {
      loading = false;
    }); //refresh UI
  }

  Future<void> _pullRefresh() async {
    await getData();
  }

  @override
  Widget build(BuildContext context) {
    sessionManager = widget.sessionManager;
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: ListView(
        children: loading
            ? [Text(AppLocalizations.of(context)!.iCanteenLoading)]
            : lunches,
      ),
    );
  }
}
