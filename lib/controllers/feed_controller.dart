
import 'package:flutter/widgets.dart';
import 'package:freeder/model/feedHistoryModel.dart';
import 'package:freeder/data/database.dart';
import 'package:freeder/services/fetchFeed.dart';

class FeedController {
  FeedController._();
  static final controller = FeedController._();

  List<feedHistoryModel> _feed = [];

  Future<List<feedHistoryModel>> getStoredPosts(feedURL) async {
     _feed = await DBProvider.db.fetchFeedHistory(feedURL);
    // fee = tmp.reversed.toList();
    // _feed = tmp + _feed;
    return _feed;
  } 

  Future<List<feedHistoryModel>> getNewPosts(feedURL) async {
    List<feedHistoryModel> tmp = await fetchFeed(feedURL);
    _feed = _feed + tmp;
    return tmp;
  }

 
}