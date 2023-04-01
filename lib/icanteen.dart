import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    getData(); //fetching data
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

    Response response = await dio.get(
      "$baseUrl/lunches",
      options: buildCacheOptions(
        const Duration(days: 1),
        forceRefresh: true,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      ),
    );

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
                          Text(
                            lunchOpt["item_name"],
                            overflow: TextOverflow.clip,
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

    setState(() {
      loading = false;
    }); //refresh UI
  }

  Future<void> _pullRefresh() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });

    String token = sharedPreferences.getString("token")!;

    Response response = await dio.get(
      "$baseUrl/lunches",
      options: buildCacheOptions(
        const Duration(days: 1),
        forceRefresh: true,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      ),
    );

    sharedPreferences.setString("lunches", jsonEncode(response.data));

    lunches = [];

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
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.check),
                            ),
                          if (!lunchOpt["can_order"])
                            const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.block),
                            ),
                          Expanded(
                            child: Text(
                              lunchOpt["item_name"],
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
      );
    }

    setState(() {
      loading = false;
    }); //refresh UI
  }

  @override
  Widget build(BuildContext context) {
    sessionManager = widget.sessionManager;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: !loading
          ? RefreshIndicator(
              onRefresh: _pullRefresh,
              child: ListView(
                children: lunches,
              ),
            )
          : const Text("Načítání obědů (Tohle by mohlo chvíli zabrat)"),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
