import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ICanteenPage extends StatefulWidget {
  final SessionManager sessionManager;

  const ICanteenPage({
    super.key,
    required this.sessionManager,
  });

  @override
  State<ICanteenPage> createState() => ICanteenPageState();
}

class ICanteenPageState extends State<ICanteenPage> {
  late SessionManager sessionManager;
  late SharedPreferences sharedPreferences;

  bool runningInit = false;

  Dio dio = Dio();

  String baseUrl = "https://lobster-app-z6jfk.ondigitalocean.app/api";
  bool loading = true;

  List<Widget> lunches = [];

  @override
  void initState() {
    super.initState();
  }

  getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);

    setState(() {
      loading = true; //make loading true to show progressindicator
    });

    String token = sharedPreferences.getString("token")!;

    Response response = await dio
        .get(
      "$baseUrl/lunches",
      options: buildCacheOptions(
        const Duration(days: 0),
        forceRefresh: true,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      ),
    )
        .catchError((obj) {
      return Response(
        requestOptions: RequestOptions(path: "$baseUrl/lunches"),
        statusCode: 500,
      );
    });

    if (response.statusCode == 500) {
      lunches.add(
        const Card(
          child: Text("Sorry, but there was an issue accessing iCanteen"),
        ),
      );
    }

    if (response.statusCode != 500) {
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
                            if (lunchOpt["ordered"]) const Icon(Icons.check),
                            if (!lunchOpt["can_order"]) const Icon(Icons.block),
                            Expanded(
                              child: Text(
                                lunchOpt["item_name"],
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
