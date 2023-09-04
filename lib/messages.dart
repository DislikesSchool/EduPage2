import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:eduapge2/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagesPage extends StatefulWidget {
  final SessionManager sessionManager;

  const MessagesPage({super.key, required this.sessionManager});

  @override
  State<MessagesPage> createState() => TimeTablePageState();
}

extension MoveElement<T> on List<T> {
  void move(int from, int to) {
    RangeError.checkValidIndex(from, this, "from", length);
    RangeError.checkValidIndex(to, this, "to", length);
    var element = this[from];
    if (from < to) {
      setRange(from, to, this, from + 1);
    } else {
      setRange(to + 1, from + 1, this, to);
    }
    this[to] = element;
  }
}

class TimeTablePageState extends State<MessagesPage> {
  bool loading = true;
  late List<dynamic> apidataMsg;

  late Widget messages;

  @override
  void initState() {
    getData(); //fetching data
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  getData() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });

    apidataMsg = await widget.sessionManager.get('messages');
    messages = getMessages(apidataMsg);

    loading = false;
    setState(() {}); //refresh UI

    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.getBool('quickstart') ?? false) {
      String token = sp.getString("token")!;
      String baseUrl = "https://lobster-app-z6jfk.ondigitalocean.app/api";
      Dio dio = Dio();
      Response response = await dio.get(
        "$baseUrl/messages",
        options: buildCacheOptions(
          const Duration(days: 5),
          maxStale: const Duration(days: 14),
          forceRefresh: true,
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
            },
          ),
        ),
      );
      widget.sessionManager.set("messages", jsonEncode(response.data));
      messages = getMessages(response.data);
      setState(() {});
    }
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

  Future<void> _pullRefresh() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });

    apidataMsg = await widget.sessionManager.get('messages');
    messages = getMessages(apidataMsg);

    loading = false;
    setState(() {}); //refresh UI
  }

  Widget getMessages(var apidataMsg) {
    HtmlUnescape unescape = HtmlUnescape();
    List<Widget> rows = <Widget>[];
    apidataMsg ??= [
      {
        "type": "sprava",
        "title": "Načítání...",
        "text": "Nebude to trvat dlouho",
      }
    ];
    List<dynamic> msgs =
        apidataMsg.where((msg) => msg["type"] == "sprava").toList();
    List<dynamic> msgsWOR = List.from(msgs);
    List<Map<String, int>> bump = [];
    for (Map<String, dynamic> msg in msgs) {
      if (msg["replyOf"] != null) {
        if (!bump.any((element) =>
            element["id"]!.compareTo(int.parse(msg["replyOf"])) == 0)) {
          bump.add(
              {"id": int.parse(msg["replyOf"]), "index": msgsWOR.indexOf(msg)});
          msgsWOR.remove(msg);
        } else {
          msgsWOR.remove(msg);
        }
      }
    }
    for (Map<String, dynamic> msg in msgsWOR) {
      String attText = msg["attachments"].length < 5
          ? msg["attachments"].length > 1
              ? "y"
              : "a"
          : "";
      rows.add(Card(
        color: msg["isSeen"]
            ? null
            : Theme.of(context).colorScheme.tertiaryContainer,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext buildContext) => MessagePage(
                        sessionManager: widget.sessionManager,
                        id: int.parse(msg["id"]))));
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      '${msg["owner"]["firstname"]?.trim()} ${msg["owner"]["lastname"]?.trim()}'
                          .replaceAll(RegExp(r'\s+'), ' '),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Icon(
                      Icons.arrow_right_rounded,
                      size: 18,
                    ),
                    Expanded(
                      child: Text(
                        unescape.convert(msg["title"]),
                        overflow: TextOverflow.fade,
                        maxLines: 5,
                        softWrap: false,
                        style: const TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        unescape.convert(msg["text"]),
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.fade,
                        maxLines: 5,
                        softWrap: false,
                      ),
                    )
                  ],
                ),
                for (Map<String, dynamic> r in msg["replies"])
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.subdirectory_arrow_right_rounded),
                      Expanded(
                        child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              r["owner"] + ": " + unescape.convert(r["text"]),
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (msg["attachments"].length > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.attach_file_rounded,
                          size: 18,
                        ),
                        Text(msg["attachments"].length.toString()),
                        Text(" Přípon$attText"),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ));
    }
    for (Map<String, int> b in bump) {
      rows.move(
          msgsWOR.indexOf(msgsWOR
              .firstWhere((element) => int.parse(element["id"]) == b["id"])),
          b["index"]!);
    }
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.messagesTitle,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 40),
                child: RefreshIndicator(
                  onRefresh: _pullRefresh,
                  child: ListView(
                    children: rows,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
