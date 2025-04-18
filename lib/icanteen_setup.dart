import 'package:dio/dio.dart';
import 'package:eduapge2/api.dart';
import 'package:eduapge2/main.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduapge2/l10n/app_localizations.dart';
import 'package:toastification/toastification.dart';

class ICanteenSetupScreen extends StatefulWidget {
  final Function loadedCallback;

  const ICanteenSetupScreen(
      {super.key, required this.sessionManager, required this.loadedCallback});

  final SessionManager sessionManager;

  @override
  BaseState<StatefulWidget> createState() => ICanteenSetupScreenState();
}

class ICanteenSetupScreenState extends BaseState<ICanteenSetupScreen> {
  late SessionManager sessionManager;
  late SharedPreferences sharedPreferences;

  String baseUrl = FirebaseRemoteConfig.instance.getString("testUrl");

  AppLocalizations? local;

  bool hasLogin = false;
  String email = "";
  String password = "";
  String server = "";
  bool showPassword = false;

  Future<void> login() async {
    setState(() {
      hasLogin = true;
    });

    EP2Data data = EP2Data.getInstance();
    Response resp = await data.dio.post(
      "${data.baseUrl}/icanteen-test",
      data: {
        "username": email,
        "password": password,
        "server": server,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        validateStatus: (status) {
          return true; // To return all status codes
        },
      ),
    );

    if (resp.statusCode == 200) {
      sharedPreferences.setString("ic_server", server);
      sharedPreferences.setString("ic_email", email);
      sharedPreferences.setString("ic_password", password);
      sharedPreferences.setBool("ice", true);

      if (mounted) {
        Navigator.pop(context);
      }
      widget.loadedCallback();
    } else {
      setState(() {
        hasLogin = false;
      });
      toastification.show(
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: Text(local!.iCanteenSetupError),
        description: Text(resp.data.toString()),
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
    }
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
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                decoration: InputDecoration(
                  icon: const Icon(Icons.key),
                  hintText: local!.iCanteenSetupPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                ),
                onChanged: (text) => {password = text},
                obscureText: !showPassword,
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
