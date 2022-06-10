import 'package:flutter/material.dart';
import 'package:freeder/controllers/feed_list_page_controller.dart';
import 'package:freeder/feed.dart';

class FeedListTile extends StatelessWidget {
  final int feedID;
  final String feedName;
  final String feedURL;
  final VoidCallback refresh;
  const FeedListTile({
    Key? key,
    required this.feedID,
    required this.feedName,
    required this.feedURL,
    required this.refresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.album, size: 50),
      title: Text(feedName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.delete, size: 25),
            onPressed: () async {
              await FeedListPageController.controller.deleteFeed(feedID);
              refresh();
            },
          ),
        ],
      ),
      onTap: () {
        FeedListPageController.controller
            .navigateTo(context, Feed(feedTitle: feedName, feedURL: feedURL));
      },
    );
  }
}
