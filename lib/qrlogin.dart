import 'package:dio/dio.dart';
import 'package:eduapge2/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QRLoginPage extends StatefulWidget {
  final String code;
  const QRLoginPage({super.key, required this.code});

  @override
  BaseState<StatefulWidget> createState() => QRLoinPageState();
}

class QRLoinPageState extends BaseState<QRLoginPage> {
  AppLocalizations? local;
  late SharedPreferences sharedPreferences;
  String email = "";
  String password = "";
  String server = "";
  bool _useCustomEndpoint = false;
  String _customEndpoint = '';
  bool showPassword = false;

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  Future<void> getPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? sEmail = sharedPreferences.getString("email");
    String? sPassword = sharedPreferences.getString("password");
    String? sServer = sharedPreferences.getString("server");
    String? sEndpoint = sharedPreferences.getString("customEndpoint");

    if (sEmail != null) {
      email = sEmail;
    }
    if (sPassword != null) {
      password = sPassword;
    }
    if (sServer != null) {
      server = sServer;
    }
    if (sEndpoint != null && sEndpoint != "") {
      _customEndpoint = sEndpoint;
      _useCustomEndpoint = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    local ??= AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    local!.qrLoginPleaseLogin,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(local!.qrLoginUseExistingCredentials),
                  TextField(
                    decoration: InputDecoration(
                      icon: const Icon(Icons.email),
                      hintText: local!.loginUsername,
                    ),
                    onChanged: (text) => {email = text},
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      icon: const Icon(Icons.key),
                      hintText: local!.loginPassword,
                      suffixIcon: IconButton(
                        icon: Icon(showPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                    ),
                    onChanged: (text) => {password = text},
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _useCustomEndpoint,
                        onChanged: (value) {
                          setState(() {
                            _useCustomEndpoint = value!;
                          });
                        },
                      ),
                      Text(local!.loginCustomEndpointCheckbox),
                    ],
                  ),
                  if (_useCustomEndpoint)
                    TextField(
                        decoration: InputDecoration(
                          icon: const Icon(Icons.language),
                          hintText: local!.loginCustomEndpoint,
                        ),
                        onChanged: (value) => {_customEndpoint = value}),
                  TextField(
                    decoration: InputDecoration(
                      icon: const Icon(Icons.cloud_queue),
                      hintText: local!.loginServer,
                    ),
                    onChanged: (text) => {server = text},
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      Dio dio = Dio();

                      var response = await dio.post(
                        'https://ep2.vypal.me/qrlogin/${widget.code}',
                        options: Options(
                          headers: {
                            Headers.contentTypeHeader:
                                Headers.formUrlEncodedContentType,
                          },
                        ),
                        data: {
                          'username': email,
                          'password': password,
                          'server': server,
                          'endpoint': _customEndpoint,
                        },
                      );

                      if (response.statusCode == 200) {
                        navigatorKey.currentState!.pop();
                      } else {
                        // If the server did not return a 200 OK response, throw an exception.
                        throw Exception('Failed to load data');
                      }
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(3),
                    ),
                    child: Text(local!.loginLogin),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
