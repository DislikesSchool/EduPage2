// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:eduapge2/home.dart';
import 'package:eduapge2/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Login page', (WidgetTester tester) async {
    // Initiates SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Gets test user's username and password from environment
    String? username = const String.fromEnvironment("USERNAME");
    String? password = const String.fromEnvironment("PASSWORD");

    // Initiates widget
    await tester.pumpWidget(const LocalizationsInj(child: LoginPage()));

    // Checks for TextFields and login button
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);

    // Types test user's credentails into fields
    await tester.enterText(find.byType(TextField).at(0), username);
    await tester.enterText(find.byType(TextField).at(1), password);
    await tester.tap(find.byType(ElevatedButton));

    // Checks that the credentails were stored correctly
    SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.get("email"), equals(username));
    expect(prefs.get("password"), equals(password));
  });

  group('TimeOfDay', () {
    TimeOfDay time1 = const TimeOfDay(hour: 4, minute: 20);
    TimeOfDay time2 = const TimeOfDay(hour: 6, minute: 09);
    test('is lesser', () => {expect(time1 < time2, true)});
    test('is lesser or equal', () => {expect(time1 <= time1, true)});
    test('is greater', () => {expect(time2 > time1, true)});
  });

  group('DateTime', () {
    DateTime parsed = DateTimeExtension.parseTime("4:20");
    test(
        'parseTime', () => {expect(parsed.hour, 4), expect(parsed.minute, 20)});
  });
}

class LocalizationsInj extends StatelessWidget {
  final Widget child;
  const LocalizationsInj({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale('en'),
      ],
      home: child,
    );
  }
}
