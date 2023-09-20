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
import 'package:webview_flutter/webview_flutter.dart';

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
  String baseUrl = FirebaseRemoteConfig.instance.getString("baseUrl");
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

    HtmlUnescape unescape = HtmlUnescape();

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
                                unescape.convert(data["title"]),
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
                        text: unescape.convert(data["text"]),
                        onOpen: _onOpen,
                      ),
                      for (Map<String, dynamic> att in data["attachments"]!)
                        if (att["name"]!.endsWith(".jpg") ||
                            att["name"]!.endsWith(".png"))
                          Image.network(att["src"]!)
                        else if (att["name"]!.endsWith(".pdf"))
                          const PDF(
                            enableSwipe: true,
                            swipeHorizontal: true,
                            autoSpacing: false,
                            pageFling: false,
                          ).cachedFromUrl(
                            att["src"],
                            placeholder: (progress) =>
                                Center(child: Text('$progress %')),
                            errorWidget: (error) =>
                                Center(child: Text(error.toString())),
                          )
                        else
                          SizedBox(
                            width: width,
                            height: 500,
                            child: WebViewWidget(
                                controller: WebViewController()
                                  ..loadRequest(Uri.parse(att["src"]!))),
                          ),
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
