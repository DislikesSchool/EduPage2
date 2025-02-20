import 'package:eduapge2/api.dart';
import 'package:eduapge2/main.dart';
import 'package:flutter/material.dart';
import 'package:eduapge2/l10n/app_localizations.dart';
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
                        fontSize: 28,
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

      double avg = 0;
      try {
        List<double> allGrades = g
            .map((grade) =>
                double.parse(grade.data) * double.parse(grade.weight) / 20)
            .toList();
        List<double> allWeights =
            g.map((grade) => double.parse(grade.weight) / 20).toList();
        avg = allGrades.reduce((a, b) => a + b) /
            allWeights.reduce((a, b) => a + b);
      } catch (e) {
        continue;
      }

      rows.add(Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        (await data.dbi.getSubject(key)).name,
                        style: TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        g.map((grade) => grade.data).join(', '),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text(avg.toStringAsFixed(2), style: TextStyle(fontSize: 24)),
                ],
              ),
            ],
          ),
        ),
      ));
    }
    return rows;
  }
}
