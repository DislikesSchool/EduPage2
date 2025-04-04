import 'package:eduapge2/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduapge2/l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  final String err;
  const LoginPage({super.key, required this.err});

  @override
  BaseState<StatefulWidget> createState() => LoinPageState();
}

class LoinPageState extends BaseState<LoginPage> {
  AppLocalizations? local;
  late SharedPreferences sharedPreferences;
  String email = "";
  String password = "";
  String server = "";
  bool _showServerField = false;
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
      _showServerField = true;
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
                    local!.loginPleaseLogin,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(local!.loginUseExistingCredentials),
                  if (widget.err != "") Text(widget.err),
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
                        decoration: InputDecoration(
                          icon: const Icon(Icons.language),
                          hintText: local!.loginCustomEndpoint,
                        ),
                        onChanged: (value) => {_customEndpoint = value}),
                  if (widget.err != "" || _showServerField)
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
                    onPressed: () => {
                      sharedPreferences.setString("email", email),
                      sharedPreferences.setString("password", password),
                      sharedPreferences.setString("server", server),
                      sharedPreferences.setString(
                          "customEndpoint", _customEndpoint),
                      sharedPreferences.setBool("demo", false),
                      Navigator.pop(context),
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
          ElevatedButton(
            onPressed: () => {
              sharedPreferences.setString("email", ""),
              sharedPreferences.setString("password", ""),
              sharedPreferences.setBool("demo", true),
              Navigator.pop(context),
            },
            child: Text(local!.loginDemoButton),
          ),
        ],
      ),
    );
  }
}
