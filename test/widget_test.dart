// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:eduapge2/api.dart';
import 'package:eduapge2/home.dart';
import 'package:eduapge2/l10n/app_localizations.dart';
import 'package:eduapge2/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimeOfDay', () {
    TimeOfDay time1 = const TimeOfDay(hour: 4, minute: 20);
    TimeOfDay time2 = const TimeOfDay(hour: 6, minute: 09);
    TimeOfDay time3 = const TimeOfDay(hour: 6, minute: 05);
    TimeOfDay time4 = const TimeOfDay(hour: 4, minute: 19);
    test('is lesser', () => {expect(time1 < time2, true)});
    test('is lesser or equal (equal)', () => {expect(time1 <= time1, true)});
    test('is lesser or equal (lesser)', () => {expect(time4 <= time1, true)});
    test('is greater', () => {expect(time2 > time3, true)});
  });

  group('DateTime', () {
    DateTime parsed = DateTimeExtension.parseTime("4:20");
    test(
        'parseTime', () => {expect(parsed.hour, 4), expect(parsed.minute, 20)});
  });

  group('List', () {
    List<int> testList = [1, 2, 3, 4, 5];
    test(
        'move forward',
        () => {
              testList.move(0, 4),
              expect(testList[0] == 2, true),
              expect(testList[4] == 1, true)
            });
    test(
        'move back',
        () => {
              testList.move(4, 0),
              expect(testList[0] == 1, true),
              expect(testList[4] == 5, true)
            });
    test(
        'move multiple',
        () => {
              testList.move(1, 3),
              testList.move(2, 4),
              expect(testList[1] == 3, true),
              expect(testList[3] == 5, true),
              expect(testList[4] == 4, true),
            });
  });

  group('API', () {
    group('Recipient', () {
      Recipient recipient = Recipient(
          id: "-1", type: RecipientType.student, name: "Test Recipient");

      test(
          'recipientString',
          () => {
                expect(recipient.recipientString(false), "StudentOnly-1"),
                expect(recipient.recipientString(true), "Student-1"),
                recipient.type = RecipientType.teacher,
                expect(recipient.recipientString(false), "Ucitel-1"),
              });
    });

    group('MessageOptions', () {
      test('toJson', () {
        MessageOptions options = MessageOptions(
          text: "Test message",
          important: true,
        );
        expect(options.toJson(), {
          "text": "Test message",
          "important": true,
          "poll": null,
        });
      });

      test('toJson with poll', () {
        PollOption opt = PollOption(text: "Option 1", id: "opt1");
        PollOptions poll = PollOptions(
          multiple: true,
          options: [opt],
        );
        MessageOptions options = MessageOptions(
          text: "Test message",
          important: true,
          poll: poll,
        );
        expect(options.toJson(), {
          "text": "Test message",
          "important": true,
          "poll": {
            "multiple": true,
            "options": [
              {"text": "Option 1", "id": "opt1"}
            ]
          },
        });
      });
    });
  });
}

class LocalizationsInj extends StatelessWidget {
  final Widget child;
  const LocalizationsInj({super.key, required this.child});

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
