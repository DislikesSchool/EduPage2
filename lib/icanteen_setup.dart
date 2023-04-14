import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ICanteenSetupScreen extends StatefulWidget {
  final Function loadedCallback;

  const ICanteenSetupScreen(
      {super.key, required this.sessionManager, required this.loadedCallback});

  final SessionManager sessionManager;

  @override
  State<StatefulWidget> createState() => ICanteenSetupScreenState();
}

class ICanteenSetupScreenState extends State<ICanteenSetupScreen> {
  late SessionManager sessionManager;
  late SharedPreferences sharedPreferences;

  Dio dio = Dio();

  String baseUrl = "https://lobster-app-z6jfk.ondigitalocean.app/api";

  AppLocalizations? local;

  bool hasLogin = false;
  String email = "";
  String password = "";
  String server = "";

/*
  Future<void> init() async {
    startedInit = true;
    sharedPreferences = await SharedPreferences.getInstance();
    progress = 0.1;
    loaderText = local!.loadCredentials;
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);
    setState(() {});
    loadMessages();
  }

  Future<void> loadMessages() async {
    progress = 0.9;
    loaderText = local!.loadDownloadMessages;
    setState(() {});
    final metric = FirebasePerformance.instance
        .newHttpMetric("$baseUrl/messages", HttpMethod.Get);

    String token = sharedPreferences.getString("token")!;
    metric.start();
    Response response = await dio.get(
      "$baseUrl/messages",
      options: buildCacheOptions(
        const Duration(days: 5),
        forceRefresh: true,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      ),
    );
    metric.stop();
    sessionManager.set("messages", jsonEncode(response.data));

    progress = 1.0;
    loaderText = local!.loadDone;
    setState(() {});
    widget.loadedCallback();
  }
*/

  Future<void> login() async {
    setState(() {
      hasLogin = true;
    });
    String? token = sharedPreferences.getString("token");
    await dio.post(
      "$baseUrl/set_icanteen",
      data: {
        'email': email,
        'password': password,
        'server': server,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    sharedPreferences.setBool("ice", true);
    widget.loadedCallback();
  }

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  Future<void> getPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    local ??= AppLocalizations.of(context);
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                local!.iCanteenSetupPleaseLogin,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(local!.iCanteenSetupDetails),
              TextField(
                decoration: InputDecoration(
                  icon: const Icon(Icons.computer_rounded),
                  hintText: local!.iCanteenSetupServer,
                ),
                onChanged: (text) => {server = text},
                keyboardType: TextInputType.url,
              ),
              TextField(
                decoration: InputDecoration(
                  icon: const Icon(Icons.email),
                  hintText: local!.iCanteenSetupEmail,
                ),
                onChanged: (text) => {email = text},
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                decoration: InputDecoration(
                  icon: const Icon(Icons.key),
                  hintText: local!.iCanteenSetupPassword,
                ),
                onChanged: (text) => {password = text},
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
              ElevatedButton(
                onPressed: () => {
                  if (!hasLogin) login(),
                },
                child: !hasLogin
                    ? Text(local!.loginLogin)
                    : const CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
