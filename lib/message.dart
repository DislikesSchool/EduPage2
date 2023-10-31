import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String baseUrl = FirebaseRemoteConfig.instance.getString("testUrl");
  bool loading = true;
  Dio dio = Dio();

  late Widget messages;

  double width = 0;

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

    sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token")!;
    Response response = await dio.get(
      "$baseUrl/api/timelineitem/${widget.id}",
      options: buildCacheOptions(
        const Duration(days: 5),
        forceRefresh: false,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      ),
    );

    HtmlUnescape unescape = HtmlUnescape();

    Map<String, dynamic> data = response.data;
    bool isImportantMessage = false;
    if (data["data"]["Value"] != null &&
        data["data"]["Value"]["messageContent"] != null) {
      isImportantMessage = true;
    }
    Iterable<dynamic> attachments = [];
    if (data["data"]["Value"] != null &&
        data["data"]["Value"]["attachements"] is Map<String, dynamic>) {
      attachments = data["data"]["Value"]["attachements"].entries;
    }
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
                              data["vlastnik_meno"],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Icon(Icons.arrow_right_rounded, size: 18),
                            Expanded(
                              child: Text(
                                unescape.convert(data["user_meno"]),
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
                      SelectableLinkify(
                        text: unescape.convert(isImportantMessage
                            ? data["data"]["Value"]["messageContent"]
                            : data["text"]),
                        onOpen: _onOpen,
                      ),
                      for (MapEntry<String, dynamic> att in attachments)
                        if (att.value.endsWith(".jpg") ||
                            att.value.endsWith(".png") ||
                            att.value.endsWith(".jpeg") ||
                            att.value.endsWith(".gif"))
                          Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15, top: 15),
                              child: Column(
                                children: [
                                  Image.network(
                                      "https://${data["origin_server"]}${att.key}"),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          unescape.convert(att.value),
                                          overflow: TextOverflow.fade,
                                          maxLines: 5,
                                          softWrap: true,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      IconButton(
                                        icon:
                                            const Icon(Icons.download_rounded),
                                        onPressed: () async {
                                          await dio.download(
                                            "https://${data["origin_server"]}${att.key}",
                                            "/storage/emulated/0/Download/${att.value}",
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        else if (att.value.endsWith(".pdf"))
                          Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Text(
                                      unescape.convert(att.value),
                                      overflow: TextOverflow.fade,
                                      maxLines: 5,
                                      softWrap: true,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.download_rounded),
                                    onPressed: () async {
                                      await dio.download(
                                        "https://${data["origin_server"]}${att.key}",
                                        "/storage/emulated/0/Download/${att.value}",
                                      );
                                    },
                                  ),
                                  // IconButton to open a new page with the pdf
                                  IconButton(
                                    icon: const Icon(Icons.open_in_new_rounded),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Scaffold(
                                            appBar: AppBar(
                                              title: Text(
                                                unescape.convert(att.value),
                                              ),
                                            ),
                                            body: const PDF(
                                              enableSwipe: true,
                                              swipeHorizontal: true,
                                              autoSpacing: false,
                                              pageFling: false,
                                            ).cachedFromUrl(
                                              "https://${data["origin_server"]}${att.key}",
                                              placeholder: (progress) => Center(
                                                  child: Text('$progress %')),
                                              errorWidget: (error) => Center(
                                                  child:
                                                      Text(error.toString())),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Text(
                                      unescape.convert(att.value),
                                      overflow: TextOverflow.fade,
                                      maxLines: 5,
                                      softWrap: true,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.download_rounded),
                                    onPressed: () async {
                                      await dio.download(
                                        "https://${data["origin_server"]}${att.key}",
                                        "/storage/emulated/0/Download/${att.value}",
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
              for (Map<String, dynamic> r in data["replies"] ?? [])
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
                          constraints: BoxConstraints(maxWidth: width),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  "${r["owner"]["firstname"]} ${r["owner"]["lastname"]}: "),
                              Text(
                                unescape.convert(r["text"]),
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

Future<void> _onOpen(LinkableElement link) async {
  if (!await launchUrl(Uri.parse(link.url),
      mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch ${link.url}');
  }
}
