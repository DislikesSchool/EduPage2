import 'package:eduapge2/api.dart';
import 'package:eduapge2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class GradesPage extends StatefulWidget {
  final SessionManager sessionManager;

  const GradesPage({super.key, required this.sessionManager});

  @override
  BaseState<GradesPage> createState() => GradesPageState();
}

class GradesPageState extends BaseState<GradesPage> {
  bool loading = true;
  late List<TimelineItem> apidataMsg;

  List<Widget> messages = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });

    apidataMsg = EP2Data.getInstance().timeline.items.values.toList();
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
          ? Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Stack(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.gradesTitle,
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: RefreshIndicator(
                        onRefresh: _pullRefresh,
                        child: ListView(
                          children: messages,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Text(AppLocalizations.of(context)!.loading),
      backgroundColor: Theme.of(context).colorScheme.surface,
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

  List<Widget> getMessages(List<TimelineItem> apidataMsg) {
    List<Widget> rows = <Widget>[];
    apidataMsg = apidataMsg.where((msg) => msg.type == "znamka").toList();
    Map<String, List<String>> grades = {};
    for (TimelineItem msg in apidataMsg) {
      String gradeInfo = msg.text.split(' - ')[1];
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
    return rows;
  }
}
