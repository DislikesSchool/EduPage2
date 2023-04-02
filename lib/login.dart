import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => LoinPageState();
}

class LoinPageState extends State<LoginPage> {
  late SharedPreferences sharedPreferences;
  String email = "";
  String password = "";

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
    AppLocalizations? local = AppLocalizations.of(context);
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
              ElevatedButton(
                onPressed: () => {
                  sharedPreferences.setString("email", email),
                  sharedPreferences.setString("password", password),
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
