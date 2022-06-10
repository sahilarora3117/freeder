import 'package:flutter/material.dart';
import 'package:freeder/data/database.dart';
import 'package:freeder/model/feedListModel.dart';

class FeedListPageController {
  FeedListPageController._();
  static final FeedListPageController controller = FeedListPageController._();
  List<feedListModelfinal> _feedList = [];

  Future<List<feedListModelfinal>> getFeedList() async {
    _feedList = await DBProvider.db.feeds();
    return _feedList;
  }

  deleteFeed(feedID) async {
    await DBProvider.db.deleteFeed(feedID);
  }

  navigateTo(BuildContext context, Widget route, VoidCallback onComplete) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => route,
      ),
    ).whenComplete(() => onComplete());
  }
}
