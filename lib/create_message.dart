import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eduapge2/api.dart';
import 'package:eduapge2/main.dart';
import 'package:flutter/material.dart';

class SendMessageScreen extends StatefulWidget {
  const SendMessageScreen({super.key});

  @override
  BaseState<SendMessageScreen> createState() => SendMessageScreenState();
}

class SendMessageScreenState extends BaseState<SendMessageScreen> {
  List<Recipient> recipients = [
    Recipient(id: "", type: RecipientType.student, name: "Select Recipient")
  ];
  String? selectedRecipient;
  String message = '';
  bool isImportant = false;
  bool includePoll = false;
  bool multipleSelection = false;
  List<PollOption> pollOptions = [];

  @override
  void initState() {
    super.initState();
    EP2Data data = EP2Data.getInstance();
    data.dio
        .get(
      "${data.baseUrl}/api/recipients",
      options: Options(
        headers: {"Authorization": "Bearer ${data.user.token}"},
      ),
    )
        .then((response) {
      List<dynamic> res = response.data;
      setState(() {
        recipients = res.map((e) => Recipient.fromJson(e)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Autocomplete<Recipient>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<Recipient>.empty();
                }
                return recipients.where((Recipient option) {
                  return option.name
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (Recipient selection) {
                setState(() {
                  selectedRecipient = selection.recipientString(false);
                });
              },
              displayStringForOption: (Recipient option) => option.name,
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    hintText: 'Select recipient',
                  ),
                );
              },
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<Recipient> onSelected,
                  Iterable<Recipient> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Recipient option = options.elementAt(index);
                        return ListTile(
                          leading: Icon(option.type == RecipientType.teacher
                              ? Icons.work
                              : Icons.school),
                          title: Text(option.name),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            TextField(
              onChanged: (value) => setState(() => message = value),
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Enter your message here',
              ),
            ),
            SwitchListTile(
              title: const Text('Important'),
              value: isImportant,
              onChanged: (bool value) {
                setState(() {
                  isImportant = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Include Poll'),
              value: includePoll,
              onChanged: (bool value) {
                setState(() {
                  includePoll = value;
                });
              },
            ),
            if (includePoll) ...[
              SwitchListTile(
                title: const Text('Multiple Selection'),
                value: multipleSelection,
                onChanged: (bool value) {
                  setState(() {
                    multipleSelection = value;
                  });
                },
              ),
              // Add widgets for adding/editing poll options here
            ],
            ElevatedButton(
              onPressed: () {
                EP2Data data = EP2Data.getInstance();

                // Create a MessageOptions object
                final messageOptions = MessageOptions(
                  text: message,
                  important: isImportant,
                  poll: includePoll
                      ? PollOptions(
                          multiple: multipleSelection, options: pollOptions)
                      : null,
                );

                // Convert the MessageOptions object to JSON
                final messageOptionsJson = jsonEncode(messageOptions);

                data.dio
                    .post(
                  "${data.baseUrl}/api/message",
                  data: {
                    "recipient": selectedRecipient,
                    "message": messageOptionsJson,
                  },
                  options: Options(
                    headers: {"Authorization": "Bearer ${data.user.token}"},
                    contentType: Headers.formUrlEncodedContentType,
                  ),
                )
                    .then((response) {
                  Navigator.of(context).pop();
                }).catchError((error) {
                  final snackBar = SnackBar(
                    content: Text(error.toString()),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              },
              child: const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
