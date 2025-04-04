import 'package:eduapge2/api.dart';
import 'package:eduapge2/message.dart';
import 'package:flutter/material.dart';
import 'package:eduapge2/l10n/app_localizations.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:html_unescape/html_unescape.dart';

class SearchMessagesPage extends StatefulWidget {
  const SearchMessagesPage({super.key});

  @override
  State<SearchMessagesPage> createState() => _SearchMessagesPageState();
}

class _SearchMessagesPageState extends State<SearchMessagesPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<TimelineItem> _searchResults = [];
  final HtmlUnescape _unescape = HtmlUnescape();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Get all messages from the timeline
    List<TimelineItem> allMessages = EP2Data.getInstance()
        .timeline
        .items
        .values
        .where((item) => item.type == "sprava")
        .toList();

    // Filter messages that contain the search query in the message body
    _searchResults = allMessages
        .where((msg) => _unescape
            .convert(msg.text)
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    // Sort by newest first
    _searchResults.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc?.messagesSearchTitle ?? 'Search Messages'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: loc?.messagesSearchHint ?? 'Enter search term...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
              ),
              onChanged: _performSearch,
            ),
          ),
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                    ? Center(
                        child: Text(
                          _searchController.text.isEmpty
                              ? loc?.messagesSearchInstructions ??
                                  'Enter a search term above'
                              : loc?.messagesNoResults ?? 'No results found',
                          style: const TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          TimelineItem msg = _searchResults[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              title: Text(
                                '${msg.ownerName} → ${_unescape.convert(msg.userName)}',
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                _unescape.convert(msg.text),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MessagePage(
                                      sessionManager: SessionManager(),
                                      id: int.parse(msg.id),
                                      date: msg.timestamp,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
