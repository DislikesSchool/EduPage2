import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  final String err;
  const LoginPage({super.key, required this.err});

  @override
  State<StatefulWidget> createState() => LoinPageState();
}

class LoinPageState extends State<LoginPage> {
  AppLocalizations? local;
  late SharedPreferences sharedPreferences;
  String email = "";
  String password = "";
  String server = "";

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
                ),
                onChanged: (text) => {password = text},
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
              if (widget.err != "")
                TextField(
                  decoration: InputDecoration(
                    icon: const Icon(Icons.cloud_queue),
                    hintText: local!.loginServer,
                  ),
                  onChanged: (text) => {server = text},
                  keyboardType: TextInputType.url,
                ),
              ElevatedButton(
                onPressed: () => {
                  sharedPreferences.setString("email", email),
                  sharedPreferences.setString("password", password),
                  sharedPreferences.setString("server", server),
                  Navigator.pop(context),
                },
                child: Text(local!.loginLogin),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
