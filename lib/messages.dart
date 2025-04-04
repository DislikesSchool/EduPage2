import 'package:eduapge2/api.dart';
import 'package:eduapge2/create_message.dart';
import 'package:eduapge2/main.dart';
import 'package:eduapge2/message.dart';
import 'package:eduapge2/search_messages.dart';
import 'package:flutter/material.dart';
import 'package:eduapge2/l10n/app_localizations.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';

class MessagesPage extends StatefulWidget {
  final SessionManager sessionManager;

  const MessagesPage({super.key, required this.sessionManager});

  @override
  BaseState<MessagesPage> createState() => TimeTablePageState();
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

class TimeTablePageState extends BaseState<MessagesPage> {
  bool loading = true;
  bool loaded = false;
  late List<dynamic> apidataMsg;
  AppLocalizations? loc;
  bool _isFetching = false;

  late Widget messages;

  final ScrollController _scrollController = ScrollController();

  bool isScrolledDown = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  getData() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });

    _scrollController.addListener(() async {
      if (!_isFetching &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 400) {
        _isFetching = true;
        await EP2Data.getInstance().timeline.loadOlderMessages();
        messages =
            getMessages(EP2Data.getInstance().timeline.items.values.toList());
        _isFetching = false;
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.minScrollExtent + 1000 !=
          isScrolledDown) {
        isScrolledDown = !isScrolledDown;
        setState(() {});
      }
    });
    messages =
        getMessages(EP2Data.getInstance().timeline.items.values.toList());

    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    loc ??= AppLocalizations.of(context);
    if (!loaded) {
      loaded = true;
      getData();
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            if (isScrolledDown)
              FloatingActionButton(
                mini: true,
                onPressed: () {
                  _scrollController.animateTo(
                    _scrollController.position.minScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Icon(Icons.arrow_upward),
              ),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext buildContext) =>
                        const SendMessageScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });

    await EP2Data.getInstance().timeline.loadNewMessages();

    messages =
        getMessages(EP2Data.getInstance().timeline.items.values.toList());

    loading = false;
    setState(() {}); //refresh UI
  }

  Widget getMessages(List<TimelineItem> apidataMsg) {
    HtmlUnescape unescape = HtmlUnescape();
    List<Widget> rows = <Widget>[];
    List<TimelineItem> msgs =
        apidataMsg.where((msg) => msg.type == "sprava").toList();
    List<TimelineItem> msgsWOR = List.from(msgs);
    List<Map<String, int>> bump = [];
    for (TimelineItem msg in msgs) {
      if (msg.reactionTo != "") {
        if (!bump.any((element) =>
            element["timelineid"]!.compareTo(int.parse(msg.reactionTo)) == 0)) {
          bump.add({
            "timelineid": int.parse(msg.reactionTo),
            "index": msgsWOR.indexOf(msg)
          });
          msgsWOR.remove(msg);
        } else {
          msgsWOR.remove(msg);
        }
      }
    }
    msgsWOR.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    for (TimelineItem msg in msgsWOR) {
      bool isImportantMessage = false;
      if (msg.data["Value"]?["messageContent"] != null) {
        isImportantMessage = true;
      }
      /*
      for (TimelineItem r in msgs
          .where((element) => element.reactionTo == msg.otherId.toString())
          .toList()) {
        print(r.id);
      }
      */
      rows.add(Card(
        //color: msg["isSeen"] ? null : Theme.of(context).colorScheme.tertiaryContainer,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext buildContext) => MessagePage(
                  sessionManager: widget.sessionManager,
                  id: int.parse(msg.id),
                  date: msg.timestamp,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    if (isImportantMessage)
                      const Text(
                        "!  ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    Text(
                      msg.ownerName.replaceAll(RegExp(r'\s+'), ' '),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Icon(
                      Icons.arrow_right_rounded,
                      size: 18,
                    ),
                    Expanded(
                      child: Text(
                        unescape.convert(msg.userName),
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
                        unescape.convert(msg.text),
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.fade,
                        maxLines: 5,
                        softWrap: false,
                      ),
                    )
                  ],
                ),
                if (msg.reactionTo == "")
                  for (TimelineItem r in msgs
                      .where(
                          (element) => element.reactionTo == msg.id.toString())
                      .toList()
                      .reversed)
                    if (r.pomocnyZaznam == "")
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
                                  "${r.ownerName}: ${unescape.convert(r.text)}",
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('yyyy-MM-dd HH:mm').format(msg.timestamp),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: [
                          if (msg.data["Value"] != null &&
                              msg.data["Value"]["attachements"] != null &&
                              msg.data["Value"]["attachements"].length > 0)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.attach_file_rounded,
                                  size: 16,
                                ),
                                Text(
                                  loc?.messagesAttachments(msg
                                          .data["Value"]["attachements"]
                                          .length) ??
                                      "",
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          if (msg.data["Value"] != null &&
                              msg.data["Value"]["votingParams"] != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.poll_rounded,
                                  size: 16,
                                ),
                                Text(
                                  loc!.messagesPoll,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                        ],
                      ),
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
      if (!msgs.any((element) => element.id == b["ineid"].toString())) continue;
      TimelineItem toBump =
          msgs.firstWhere((element) => element.id == b["ineid"].toString());
      rows.move(msgsWOR.indexOf(toBump), b["index"]!);
    }
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.messagesTitle,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const SearchMessagesPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: RefreshIndicator(
                onRefresh: _pullRefresh,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: rows.length,
                  itemBuilder: (BuildContext context, int index) {
                    return rows[index];
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
