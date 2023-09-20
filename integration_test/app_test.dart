import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:eduapge2/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    String? username = const String.fromEnvironment("USERNAME");
    String? password = const String.fromEnvironment("PASSWORD");
    String? name = const String.fromEnvironment("NAME");

    testWidgets('Run app and login', (tester) async {
      await prep(tester, username, password, name);
      expect(find.text("Username"), findsNothing);
    });

    testWidgets('Test TimeTable page', (tester) async {
      await prep(tester, username, password, name);

      await tester.tap(find.byType(NavigationDestination).at(1));
      await pumpUntilFound(tester, find.textContaining("Today"));
      expect(find.textContaining("TODAY"), findsOneWidget);
    });

    testWidgets('Test TimeTable page scroll', (tester) async {
      await prep(tester, username, password, name);

      await tester.tap(find.byType(NavigationDestination).at(1));
      await pumpUntilFound(tester, find.textContaining("Today"));
      expect(find.textContaining("TODAY"), findsOneWidget);

      await tester.tap(find.byKey(const Key("TimeTableScrollForward")));
      await pumpUntilFound(tester, find.textContaining("Tomorrow"));
      expect(find.textContaining("TOMORROW"), findsOneWidget);
    });
  });
}

Future<void> prep(
    WidgetTester tester, String username, String password, String name) async {
  SharedPreferences.setMockInitialValues({});
  final FlutterExceptionHandler? originalOnError = FlutterError.onError;
  app.main();
  await tester.pumpAndSettle();
  FlutterError.onError = originalOnError;
  await pumpUntilFound(tester, find.text("Username"));

  await tester.enterText(find.byType(TextField).at(0), username);
  await tester.enterText(find.byType(TextField).at(1), password);
  await tester.tap(find.byType(ElevatedButton));

  await pumpUntilFound(tester, find.text(name));
  await tester.pump(const Duration(seconds: 1));
}
