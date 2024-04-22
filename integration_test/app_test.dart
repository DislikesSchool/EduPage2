import 'package:eduapge2/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:eduapge2/main.dart' as app;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    String? username = const String.fromEnvironment("USERNAME");
    String? password = const String.fromEnvironment("PASSWORD");
    String? name = const String.fromEnvironment("NAME");

    String token = "";

    testWidgets('Run app and login', (tester) async {
      await prep(tester, username, password, name, true, "https://ep2.vypal.me",
          false, "");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token") ?? "";
      expect(find.text(name), findsWidgets);
      expect(find.text("Username"), findsNothing);
    });

    testWidgets('Test TimeTable page', (tester) async {
      await prep(tester, username, password, name, false, "", false, token);

      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.byType(NavigationDestination).at(1));
      await tester.pump(const Duration(seconds: 1));
      String day = DateFormat('d', const Locale('en', 'US').toString())
          .format(DateTime.now());
      String month = DateFormat('MMMM', const Locale('en', 'US').toString())
          .format(DateTime.now());

      await pumpUntilFound(tester, find.textContaining("$day $month"));
      expect(find.textContaining("$day $month"), findsWidgets);
    });

    testWidgets('Test TimeTable page scroll', (tester) async {
      await prep(tester, username, password, name, false, "", true, token);

      await tester.tap(find.byType(NavigationDestination).at(1));
      await tester.pump(const Duration(seconds: 1));
      String day = DateFormat('d', const Locale('en', 'US').toString())
          .format(DateTime.now());
      String month = DateFormat('MMMM', const Locale('en', 'US').toString())
          .format(DateTime.now());

      await pumpUntilFound(tester, find.textContaining("$day $month"));
      expect(find.textContaining("$day $month"), findsWidgets);

      await tester.tap(find.byKey(const Key("TimeTableScrollForward")));
      await tester.pump(const Duration(seconds: 1));
      day = DateFormat('d', const Locale('en').toString())
          .format(DateTime.now().add(const Duration(days: 1)));
      month = DateFormat('MMMM', const Locale('en').toString())
          .format(DateTime.now().add(const Duration(days: 1)));

      await pumpUntilFound(tester, find.textContaining("$day $month"));
      expect(find.textContaining("$day $month"), findsWidgets);
    });

    testWidgets('Test Messages page', (tester) async {
      await prep(tester, username, password, name, false, "", true, token);

      await tester.tap(find.byType(NavigationDestination).at(2));
      await tester.pump(const Duration(seconds: 1));

      await pumpUntilFound(tester, find.text("Messages"));
      expect(find.text("Messages"), findsWidgets);
      expect(find.byType(Card), findsWidgets);
    });
    testWidgets('Test Message page', (tester) async {
      await prep(tester, username, password, name, false, "", false, "");

      await tester.tap(find.byType(NavigationDestination).at(2));

      await pumpUntilFound(tester, find.text("Messages"));
      expect(find.text("Messages"), findsWidgets);
      Finder f = find.byWidgetPredicate((widget) =>
          widget is Icon &&
          widget.size == 18 &&
          widget.icon == Icons.arrow_right_rounded);
      await pumpUntilFound(tester, f);
      expect(f, findsWidgets);

      await tester.tap(f.at(0));
      await tester.pump(const Duration(seconds: 1));

      await pumpUntilFound(tester, f);
      expect(f, findsOneWidget);
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('Test Homework page', (tester) async {
      await prep(tester, username, password, name, false, "", true, token);

      await tester.tap(find.byType(NavigationDestination).at(3));
      await tester.pump(const Duration(seconds: 1));

      await pumpUntilFound(tester, find.text("Homework"));
      expect(find.text("Homework"), findsWidgets);
      expect(find.byType(Card), findsWidgets);
    });
  });
}

Future<void> prep(
    WidgetTester tester,
    String username,
    String password,
    String name,
    bool enableiCanteen,
    String customEndPoint,
    bool quickstart,
    String token) async {
  SharedPreferences.setMockInitialValues({
    "ice": enableiCanteen,
    "customEndpoint": customEndPoint,
    "quickstart": quickstart,
    "token": token
  });
  final FlutterExceptionHandler? originalOnError = FlutterError.onError;
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
  await remoteConfig.activate();
  runApp(const MyTestApp());
  await tester.pumpAndSettle();
  FlutterError.onError = originalOnError;
  await pumpUntilFound(tester, find.text("Username"));

  await tester.enterText(find.byType(TextField).at(0), username);
  await tester.enterText(find.byType(TextField).at(1), password);
  await tester.tap(find.byType(ElevatedButton).at(0));

  await pumpUntilFound(tester, find.text(name));
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 1));
}

class MyTestApp extends StatelessWidget {
  const MyTestApp({super.key});
  static final _defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.blue);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue, brightness: Brightness.dark);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduPage2',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: _defaultLightColorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: _defaultDarkColorScheme,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const app.PageBase(),
    );
  }
}
