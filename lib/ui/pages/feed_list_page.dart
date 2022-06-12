import 'dart:ffi';

import 'package:flutter/material.dart';
// Pages
import 'add_feed_page.dart';
import 'settings_page.dart';
import 'saved_posts_page.dart';
// Shared
import 'package:freeder/ui/shared/post/feed_tile.dart';
import 'package:freeder/ui/shared/nothing_to_show.dart';
// Models
import '../../model/feedListModel.dart';
import 'package:freeder/controllers/feed_list_page_controller.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<feedListModelfinal> feedList = [];
  bool feedListState = false;

  _refresh() async {
    List<feedListModelfinal> localFeed =
        await FeedListPageController.controller.getFeedList();
    setState(() {
      feedList = localFeed;
      feedListState = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Freeder'),
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                FeedListPageController.controller.navigateTo(
                  context,
                  const Saved(),
                  () {
                    return;
                  },
                );
              },
              child: const Icon(Icons.star),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                FeedListPageController.controller.navigateTo(
                  context,
                  const settings(),
                  () {
                    return;
                  },
                );
              },
              child: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: (!feedListState)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : feedList.isEmpty
              ? const NothingToShow(
                  nothingText: "Nothing but crickets here.",
                )
              : ListView(
                  children: [
                    for (int i = 0; i < feedList.length; i++)
                      FeedListTile(
                        feedID: feedList[i].ID as int,
                        feedName: feedList[i].feedName,
                        feedURL: feedList[i].feedUrl,
                        refresh: _refresh,
                      ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FeedListPageController.controller
              .navigateTo(context, const addFeed(), _refresh);
        },
        tooltip: "Add Feed",
        child: const Icon(Icons.add),
      ),
    );
    // }
  }
}
