import 'dart:async';
import 'package:eduapge2/api.dart';
import 'package:eduapge2/login.dart';
import 'package:eduapge2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduapge2/l10n/app_localizations.dart';

class LoadingScreen extends StatefulWidget {
  final Function loadedCallback;

  const LoadingScreen(
      {super.key, required this.sessionManager, required this.loadedCallback});

  final SessionManager sessionManager;

  @override
  BaseState<StatefulWidget> createState() => LoadingScreenState();
}

class LoadingScreenState extends BaseState<LoadingScreen> {
  late SessionManager sessionManager;
  late SharedPreferences sharedPreferences;

  bool startedInit = false;

  double progress = 0.0;
  String loaderText = "Loading...";

  late AppLocalizations? local;

  @override
  void initState() {
    super.initState();
  }

  Future<void> init() async {
    if (startedInit) return;
    startedInit = true;
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool("ice") == true) {
      sessionManager.set("iCanteenEnabled", true);
    }
    progress = 0.1;
    loaderText = local!.loadCredentials;
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
