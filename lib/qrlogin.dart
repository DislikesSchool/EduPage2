import 'package:dio/dio.dart';
import 'package:eduapge2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _useCustomEndpoint = false;
  bool showPassword = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController serverController = TextEditingController();
  TextEditingController customEndpointController = TextEditingController();

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
      emailController.text = sEmail;
    }
    if (sPassword != null) {
      passwordController.text = sPassword;
    }
    if (sServer != null) {
      serverController.text = sServer;
    }
    if (sEndpoint != null && sEndpoint != "") {
      customEndpointController.text = sEndpoint;
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
                    controller: emailController,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.email),
                      hintText: local!.loginUsername,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: passwordController,
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
                    obscureText: !showPassword,
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
                      controller: customEndpointController,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.language),
                        hintText: local!.loginCustomEndpoint,
                      ),
                    ),
                  TextField(
                    controller: serverController,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.cloud_queue),
                      hintText: local!.loginServer,
                    ),
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
                          'username': emailController.text,
                          'password': passwordController.text,
                          'server': serverController.text,
                          'endpoint': customEndpointController.text,
                        },
                      );

                      if (response.statusCode == 200) {
                        SystemNavigator.pop();
                      } else {
                        throw Exception('Failed to load data');
                      }
                    },
                    style: ButtonStyle(
                      elevation: WidgetStateProperty.all(3),
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
