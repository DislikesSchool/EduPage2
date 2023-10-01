import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:eduapge2/homework.dart';
import 'package:eduapge2/icanteen.dart';
import 'package:eduapge2/load.dart';
import 'package:eduapge2/messages.dart';
import 'package:eduapge2/timetable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'home.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://9c458db0f7204c84946c2d8ca59556ed@o4504950085976064.ingest.sentry.io/4504950092136448';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );
  OneSignal.shared.setAppId("85587dc6-0a3c-4e91-afd6-e0ca82361763");
  OneSignal.shared.promptUserForPushNotificationPermission();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  static final _defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.blue);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue, brightness: Brightness.dark);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        title: 'EduPage2',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        navigatorObservers: [SentryNavigatorObserver(), observer],
        theme: ThemeData(
          colorScheme: lightColorScheme ?? _defaultLightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.dark,
        home: const PageBase(),
      );
    });
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
  List<dynamic> apidataMsg = [];
  bool refresh = true;
  bool iCanteenEnabled = false;
  bool _isCheckingForUpdate = false;
  final ShorebirdCodePush _shorebirdCodePush = ShorebirdCodePush();

  SessionManager sessionManager = SessionManager();

  @override
  void initState() {
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);
    getMsgs();
    if (!_isCheckingForUpdate) _checkForUpdate(); // ik that it's not necessary
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _checkForUpdate() async {
    setState(() {
      _isCheckingForUpdate = true;
    });

    // Ask the Shorebird servers if there is a new patch available.
    final isUpdateAvailable =
        await _shorebirdCodePush.isNewPatchAvailableForDownload();

    if (!mounted) return;

    setState(() {
      _isCheckingForUpdate = false;
    });

    if (isUpdateAvailable) {
      _downloadUpdate();
    }
  }

  void _showDownloadingBanner() {
    ScaffoldMessenger.of(context).showMaterialBanner(
      const MaterialBanner(
        content: Text('Downloading patch...'),
        actions: [
          SizedBox(
            height: 14,
            width: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
        ],
      ),
    );
  }

  void _showRestartBanner() {
    ScaffoldMessenger.of(context).showMaterialBanner(
      const MaterialBanner(
        content: Text('A new patch is ready!'),
        actions: [
          TextButton(
            // Restart the app for the new patch to take effect.
            onPressed: Restart.restartApp,
            child: Text('Restart app'),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadUpdate() async {
    _showDownloadingBanner();
    await _shorebirdCodePush.downloadUpdateIfAvailable();
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    _showRestartBanner();
  }

  initRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await remoteConfig.setDefaults(const {
      "baseUrl": "https://lobster-app-z6jfk.ondigitalocean.app/api",
      "testUrl": "https://edupage2server-1-c5607538.deta.app/"
    });
    await remoteConfig.fetchAndActivate();
    baseUrl = remoteConfig.getString("testUrl");
  }

  getMsgs() async {
    await initRemoteConfig();
    var msgs = await sessionManager.get('messages');
    var ic = await sessionManager.get('iCanteenEnabled');
    if (ic == true) {
      iCanteenEnabled = true;
    }
    if (msgs != Null && msgs != null) {
      setState(() {
        apidataMsg = msgs.values.toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !loaded
        ? Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
            ),
            body: LoadingScreen(
              sessionManager: sessionManager,
              loadedCallback: () {
                getMsgs();
                setState(() {
                  loaded = true;
                });
              },
            ),
          )
        : Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: <Widget>[
                HomePage(
                  sessionManager: sessionManager,
                  reLogin: () {
                    setState(() {
                      loaded = false;
                    });
                  },
                  onDestinationSelected: _onDestinationSelected,
                ),
                TimeTablePage(
                  sessionManager: sessionManager,
                ),
                if (iCanteenEnabled)
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
                if (iCanteenEnabled)
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
