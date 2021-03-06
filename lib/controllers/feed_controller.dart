
import 'package:freeder/model/feedHistoryModel.dart';
import 'package:freeder/data/database.dart';
import 'package:freeder/services/fetchFeed.dart';

class FeedController {
  FeedController._();
  static final controller = FeedController._();

  List<feedHistoryModel> _feed = [];

  Future<List<feedHistoryModel>> getStoredPosts(feedURL) async {
     _feed = await DBProvider.db.fetchFeedHistory(feedURL);
    return _feed;
  } 

  Future<List<feedHistoryModel>> getNewPosts(feedURL) async {
    List<feedHistoryModel> tmp = await fetchFeed(feedURL);
    return tmp;
  }

 
}