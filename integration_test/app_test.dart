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

      SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(prefs.get("email"), equals(username));
      expect(prefs.get("password"), equals(password));
    });

    testWidgets('Test TimeTable page', (tester) async {
      await prep(tester, username, password, name);

      await tester.tap(find.byType(NavigationDestination).at(1));
      await tester.pump();
      expect(find.textContaining("Today"), findsOneWidget);
    });

    testWidgets('Test TimeTable page scroll', (tester) async {
      await prep(tester, username, password, name);

      await tester.tap(find.byType(NavigationDestination).at(1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.textContaining("Today"), findsOneWidget);

      await tester.tap(find.byType(Icon).at(3));
      await tester.pump(const Duration(seconds: 1));
      expect(find.textContaining("Tomorrow"), findsOneWidget);
    });
  });
}

Future<void> prep(
    WidgetTester tester, String username, String password, String name) async {
  SharedPreferences.setMockInitialValues({});
  app.main();
  await tester.pumpAndSettle();
  await pumpUntilFound(tester, find.text("Username"));

  await tester.enterText(find.byType(TextField).at(0), username);
  await tester.enterText(find.byType(TextField).at(1), password);
  await tester.tap(find.byType(ElevatedButton));

  await pumpUntilFound(tester, find.text(name));
}
