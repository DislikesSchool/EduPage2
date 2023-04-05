import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagePage extends StatefulWidget {
  final SessionManager sessionManager;
  final int id;

  const MessagePage(
      {super.key, required this.sessionManager, required this.id});

  @override
  State<MessagePage> createState() => MessagePageState();
}

class MessagePageState extends State<MessagePage> {
  late SessionManager sessionManager;
  late SharedPreferences sharedPreferences;
  String baseUrl = "https://lobster-app-z6jfk.ondigitalocean.app/api";
  bool loading = true;
  Dio dio = Dio();

  late Widget messages;

  @override
  void initState() {
    getData(); //fetching data
    super.initState();
  }

  getData() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });

    sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token")!;
    Response response = await dio.get(
      "$baseUrl/message/${widget.id}",
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

    Map<String, dynamic> data = response.data;
    messages = ListView(
      children: [
        Row(
          children: [
            Text(data["owner"]["firstname"] + " " + data["owner"]["lastname"]),
            const Icon(Icons.arrow_right_rounded),
            Expanded(
              child: Text(
                data["title"],
                overflow: TextOverflow.fade,
                maxLines: 5,
                softWrap: false,
              ),
            )
          ],
        ),
        Text(data["text"]),
        for (Map<String, dynamic> att in data["attachments"]!)
          Image.network(att["src"])
      ],
    );

    loading = false;
    setState(() {}); //refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: !loading
          ? Stack(
              children: <Widget>[messages],
            )
          : Text(AppLocalizations.of(context)!.loading),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
