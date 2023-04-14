import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:html_unescape/html_unescape.dart';
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

  double width = 0;

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
    messages = Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 60, top: 5),
                        child: Row(
                          children: [
                            Text(
                              data["owner"]["firstname"] +
                                  " " +
                                  data["owner"]["lastname"],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Icon(Icons.arrow_right_rounded, size: 18),
                            Expanded(
                              child: Text(
                                data["title"],
                                overflow: TextOverflow.fade,
                                maxLines: 5,
                                softWrap: true,
                                style: const TextStyle(fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(data["text"]),
                      for (Map<String, dynamic> att in data["attachments"]!)
                        Image.network(att["src"]),
                    ],
                  ),
                ),
              ),
              for (Map<String, dynamic> r in data["replies"])
                Row(
                  children: [
                    const SizedBox(width: 20),
                    const Icon(Icons.subdirectory_arrow_right_rounded,
                        size: 32),
                    Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          constraints:
                              BoxConstraints(maxHeight: 200, maxWidth: width),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  "${r["owner"]["firstname"]} ${r["owner"]["lastname"]}: "),
                              Text(
                                HtmlUnescape().convert(r["text"]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        Positioned(
          top: 15,
          left: 15,
          child: Card(
            elevation: 10,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 40,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );

    loading = false;
    setState(() {}); //refresh UI
  }

  @override
  Widget build(BuildContext context) {
    if (width == 0) {
      setState(() {
        width = MediaQuery.of(context).size.width - 100;
      });
    }
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
