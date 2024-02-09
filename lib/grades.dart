import 'package:eduapge2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GradesPage extends StatefulWidget {
  final SessionManager sessionManager;

  const GradesPage({super.key, required this.sessionManager});

  @override
  BaseState<GradesPage> createState() => GradesPageState();
}

class GradesPageState extends BaseState<GradesPage> {
  bool loading = true;
  late List<dynamic> apidataMsg;

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

    apidataMsg = await widget.sessionManager.get('messages');
    messages = getMessages(apidataMsg);

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
    List<Widget> rows = <Widget>[];
    apidataMsg ??= [
      {
        "type": "znamka",
        "title": "Načítání...",
        "text": "Nebude to trvat dlouho",
      }
    ];
    apidataMsg = apidataMsg.where((msg) => msg["type"] == "znamka").toList();
    Map<String, List<String>> grades = {};
    for (Map<String, dynamic> msg in apidataMsg) {
      String gradeInfo = msg["text"].split(' - ')[1];
      String className = gradeInfo.split(': ')[0];
      String grade = gradeInfo.split(': ')[1];
      if (!grades.containsKey(className)) grades[className] = [];
      grades[className]?.add(grade);
    }
    for (String key in grades.keys) {
      List<String>? g = grades[key];
      if (g == null) continue;
      rows.add(Card(
        child: Row(
          children: [Text(key), for (String grade in g) Text(grade)],
        ),
      ));
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
