import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:eduapge2/homework.dart';
import 'package:eduapge2/icanteen.dart';
import 'package:eduapge2/load.dart';
import 'package:eduapge2/messages.dart';
import 'package:eduapge2/timetable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduPage2',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const PageBase(),
    );
  }
}

class PageBase extends StatefulWidget {
  const PageBase({super.key});

  @override
  State<PageBase> createState() => PageBaseState();
}

class PageBaseState extends State<PageBase> {
  int _selectedIndex = 0;
  String baseUrl = "https://lobster-app-z6jfk.ondigitalocean.app";
  late Response response;
  Dio dio = Dio();

  bool loaded = false;

  bool error = false; //for error status
  bool loading = false; //for data featching status
  String errmsg = ""; //to assing any error message from API/runtime
  late List<Map<String, dynamic>> apidataMsg;
  bool refresh = true;

  SessionManager sessionManager = SessionManager();

  @override
  void initState() {
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);
    //getData(); //fetching data
    getMsgs();
    //Timer.periodic(const Duration(seconds: 2), (Timer t) => {getData()});
    super.initState();
  }

  getMsgs() async {
    apidataMsg = await sessionManager.get('messages');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: !loaded
          ? LoadingScreen(
              sessionManager: sessionManager,
              loadedCallback: () {
                setState(() {
                  loaded = true;
                });
              },
            )
          : IndexedStack(
              index: _selectedIndex,
              children: <Widget>[
                HomePage(
                  sessionManager: sessionManager,
                ),
                TimeTablePage(
                  sessionManager: sessionManager,
                ),
                ICanteenPage(
                  sessionManager: sessionManager,
                ),
                MessagesPage(
                  sessionManager: sessionManager,
                ),
                HomeworkPage(
                  sessionManager: sessionManager,
                )
              ],
            ),
      bottomNavigationBar: NavigationBar(
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.mainHome,
            selectedIcon: const Icon(Icons.home_outlined),
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month),
            label: AppLocalizations.of(context)!.mainTimetable,
            selectedIcon: const Icon(Icons.calendar_month_outlined),
          ),
          NavigationDestination(
            icon: const Icon(Icons.lunch_dining_rounded),
            label: AppLocalizations.of(context)!.mainICanteen,
            selectedIcon: const Icon(Icons.lunch_dining_outlined),
          ),
          NavigationDestination(
            icon: Badge(
              label: Text(apidataMsg
                  .where((msg) => msg["isSeen"] == false)
                  .toList()
                  .length
                  .toString()),
              child: const Icon(Icons.mail),
            ),
            label: AppLocalizations.of(context)!.mainMessages,
            selectedIcon: Badge(
              label: Text(apidataMsg
                  .where((msg) => msg["isSeen"] == false)
                  .toList()
                  .length
                  .toString()),
              child: const Icon(Icons.mail_outline),
            ),
          ),
          NavigationDestination(
            icon: const Icon(Icons.home_work),
            label: AppLocalizations.of(context)!.mainHomework,
            selectedIcon: const Icon(Icons.home_work_outlined),
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (dest) => {
          setState(() {
            _selectedIndex = dest;
          })
        },
      ),
    );
  }
}
