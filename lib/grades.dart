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

  final EP2Data data = EP2Data.getInstance();

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

    messages = await getMessages(EP2Data.getInstance().grades);

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

    messages = await getMessages(EP2Data.getInstance().grades);

    loading = false;
    setState(() {}); //refresh UI
  }

  Future<List<Widget>> getMessages(Grades results) async {
    List<Widget> rows = <Widget>[];
    Map<String, List<Event>> grades = {};
    for (Event msg in results.events.values) {
      if (msg.data == "") continue;
      if (!grades.containsKey(msg.subjectID)) grades[msg.subjectID] = [];
      grades[msg.subjectID]?.add(msg);
    }
    for (String key in grades.keys) {
      List<Event>? g = grades[key];
      if (g == null) continue;
      if ((await data.dbi.getSubject(key)).name == "") continue;
      rows.add(Card(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  (await data.dbi.getSubject(key)).name,
                  style: TextStyle(
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              children: [Text(g.map((grade) => grade.data).join(', '))],
            ),
          ],
        ),
      ));
    }
    return rows;
  }
}
