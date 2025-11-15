import 'package:eduapge2/api.dart';
import 'package:eduapge2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:eduapge2/l10n/app_localizations.dart';

class HomeworkPage extends StatefulWidget {
  final SessionManager sessionManager;

  const HomeworkPage({super.key, required this.sessionManager});

  @override
  BaseState<HomeworkPage> createState() => HomeworkPageState();
}

class HomeworkPageState extends BaseState<HomeworkPage> {
  bool loading = true;
  bool loaded = false;
  late List<dynamic> apidataMsg;

  late Widget messages;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getData() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });

    messages =
        getMessages(EP2Data.getInstance().timeline.homeworks.values.toList());

    loading = false;
    setState(() {}); //refresh UI
  }

  @override
  Widget build(BuildContext context) {
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
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });
    messages =
        getMessages(EP2Data.getInstance().timeline.homeworks.values.toList());

    loading = false;
    setState(() {}); //refresh UI
  }

  Widget getMessages(List<Homework> apidataMsg) {
    List<Widget> rows = <Widget>[];
    for (Homework msg in apidataMsg) {
      String textAsTitle = "This isn't supposed to happen...";
      if (msg.name != "") {
        textAsTitle = msg.name;
      } else {
        continue;
      }
      rows.add(Card(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(msg.authorName),
                    const Icon(Icons.arrow_right_rounded),
                    Expanded(
                      child: Text(
                        msg.lessonName,
                        overflow: TextOverflow.fade,
                        maxLines: 5,
                        softWrap: false,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        textAsTitle,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.fade,
                        maxLines: 5,
                        softWrap: false,
                      ),
                    )
                  ],
                ),
              ],
            )),
      ));
    }
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.homeworkTitle,
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
