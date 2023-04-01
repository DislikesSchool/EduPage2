import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class MessagePage extends StatefulWidget {
  final SessionManager sessionManager;

  const MessagePage({
    super.key,
    required this.sessionManager,
  });

  @override
  State<MessagePage> createState() => MessagePageState();
}

class MessagePageState extends State<MessagePage> {
  bool loading = true;
  var apidata_msg;

  late Widget messages;

  @override
  void initState() {
    getData(); //fetching data
    super.initState();
  }

  getData() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });

    apidata_msg = await widget.sessionManager.get('messages');

    loading = false;
    setState(() {}); //refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: !loading
          ? Stack(
              children: <Widget>[messages],
            )
          : const Text("Načítání..."),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
