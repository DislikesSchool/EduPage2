import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Prosím se přihlašte",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const Text("Použijte vaše existující přihlašovací údaje"),
              TextField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: "Uživatelské jméno",
                ),
                onChanged: (text) => {email = text},
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.key),
                  hintText: "Heslo",
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
                child: const Text("Přihlásit se"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
