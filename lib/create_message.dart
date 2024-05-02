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
  String newOption = '';
  bool isImportant = false;
  bool includePoll = false;
  bool multipleSelection = false;
  List<PollOption> pollOptions = [];
  TextEditingController pollOptionController = TextEditingController();

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
    return PopScope(
      canPop: message.isEmpty,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Discard message?'),
              content: const Text(
                  'You have not sent the message yet. Are you sure you want to discard it?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text('Discard'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Send Message'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Autocomplete<Recipient>(
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
                        contentPadding: EdgeInsets.all(8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  minLines: 4,
                  onChanged: (value) => setState(() => message = value),
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Enter your message here',
                    contentPadding: EdgeInsets.all(8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                  ),
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
              if (includePoll)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Multiple Selection'),
                          value: multipleSelection,
                          onChanged: (bool value) {
                            setState(() {
                              multipleSelection = value;
                            });
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: pollOptionController,
                                onChanged: (value) =>
                                    setState(() => newOption = value),
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  hintText: 'New option',
                                  contentPadding: EdgeInsets.all(8.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (newOption.isNotEmpty) {
                                    pollOptions.add(PollOption(
                                      text: newOption,
                                      id: DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                    ));
                                    newOption = '';
                                    pollOptionController.clear();
                                  }
                                });
                              },
                              child: const Icon(Icons.add_rounded),
                            ),
                          ],
                        ),
                        if (pollOptions.isNotEmpty) const Divider(),
                        ReorderableListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: pollOptions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              key: ValueKey(pollOptions[index].id),
                              title: Text(pollOptions[index].text),
                              leading: const Icon(Icons.drag_handle_rounded),
                              trailing: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      const Color.fromARGB(255, 152, 1, 29)),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                ),
                                child: const Icon(Icons.delete_rounded),
                                onPressed: () {
                                  setState(() {
                                    pollOptions.removeAt(index);
                                  });
                                },
                              ),
                            );
                          },
                          onReorder: (int oldIndex, int newIndex) {
                            setState(() {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              final PollOption item =
                                  pollOptions.removeAt(oldIndex);
                              pollOptions.insert(newIndex, item);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  EP2Data data = EP2Data.getInstance();

                  if (selectedRecipient == null) {
                    const snackBar = SnackBar(
                      content: Text('Please select a recipient'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }

                  if (message.isEmpty) {
                    const snackBar = SnackBar(
                      content: Text('Please enter a message'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }

                  final messageOptions = MessageOptions(
                    text: message,
                    important: isImportant,
                    poll: includePoll
                        ? PollOptions(
                            multiple: multipleSelection, options: pollOptions)
                        : null,
                  );

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
      ),
    );
  }
}
