import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:eduapge2/api.dart';
import 'package:eduapge2/homework.dart';
import 'package:eduapge2/icanteen.dart';
import 'package:eduapge2/load.dart';
import 'package:eduapge2/messages.dart';
import 'package:eduapge2/qrlogin.dart';
import 'package:eduapge2/timetable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'home.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await remoteConfig.setDefaults(const {
    "baseUrl": "https://lobster-app-z6jfk.ondigitalocean.app/api",
    "testUrl": "https://ep2.vypal.me"
  });
  await remoteConfig.fetchAndActivate();
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://9c458db0f7204c84946c2d8ca59556ed@o4504950085976064.ingest.sentry.io/4504950092136448';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );
  //OneSignal.shared.setAppId("85587dc6-0a3c-4e91-afd6-e0ca82361763");
  //OneSignal.shared.promptUserForPushNotificationPermission();
}

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  static final _defaultLightColorScheme =
      ThemeData(colorSchemeSeed: const Color.fromARGB(255, 105, 140, 243))
          .colorScheme;

  static final _defaultDarkColorScheme = ThemeData(
          colorSchemeSeed: const Color.fromARGB(255, 105, 140, 243),
          brightness: Brightness.dark)
      .colorScheme;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return ToastificationWrapper(
        child: MaterialApp(
          title: 'EduPage2',
          navigatorKey: navigatorKey,
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
        ),
      );
    });
  }
}

class PageBase extends StatefulWidget {
  const PageBase({super.key});

  @override
  BaseState<PageBase> createState() => PageBaseState();
}

class PageBaseState extends BaseState<PageBase> {
  int _selectedIndex = 0;
  String baseUrl = FirebaseRemoteConfig.instance.getString("testUrl");

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  bool loaded = false;

  bool error = false; //for error status
  bool loading = false; //for data featching status
  String errmsg = ""; //to assing any error message from API/runtime
  List<TimelineItem> apidataMsg = [];
  bool refresh = true;
  bool iCanteenEnabled = false;
  bool _isCheckingForUpdate = false;
  final ShorebirdUpdater _shorebirdCodePush = ShorebirdUpdater();

  SessionManager sessionManager = SessionManager();

  @override
  void initState() {
    setOptimalDisplayMode();
    if (!_isCheckingForUpdate) _checkForUpdate(); // ik that it's not necessary
    super.initState();
    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (uri.path.startsWith('/l/')) {
        final code = uri.pathSegments[1];
        navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (context) => QRLoginPage(
            code: code,
          ),
        ));
      }
    });
  }

  Future<void> setOptimalDisplayMode() async {
    final List<DisplayMode> supported = await FlutterDisplayMode.supported;
    final DisplayMode active = await FlutterDisplayMode.active;

    final List<DisplayMode> sameResolution = supported
        .where((DisplayMode m) =>
            m.width == active.width && m.height == active.height)
        .toList()
      ..sort((DisplayMode a, DisplayMode b) =>
          b.refreshRate.compareTo(a.refreshRate));

    final DisplayMode mostOptimalMode =
        sameResolution.isNotEmpty ? sameResolution.first : active;

    await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
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
    final isUpdateAvailable = await _shorebirdCodePush.checkForUpdate();

    if (!mounted) return;

    setState(() {
      _isCheckingForUpdate = false;
    });

    if (isUpdateAvailable == UpdateStatus.outdated) {
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
    await _shorebirdCodePush.update();
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    _showRestartBanner();
  }

  getMsgs() async {
    apidataMsg = EP2Data.getInstance().timeline.items.values.toList();
    dynamic ic = await sessionManager.get('iCanteenEnabled');
    if (ic.runtimeType == bool && ic == true) {
      iCanteenEnabled = true;
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
                /*
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
                */
                NavigationDestination(
                  icon: const Icon(Icons.mail),
                  label: AppLocalizations.of(context)!.mainMessages,
                  selectedIcon: const Icon(Icons.mail_outline),
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
