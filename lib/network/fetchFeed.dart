import 'dart:async';
import 'package:http/http.dart' as http;
import '../data/database.dart';
import 'package:webfeed/webfeed.dart';
import '../model/feedHistoryModel.dart';

Future<List<feedHistoryModel>> fetchFeed(String feedURL) async {
  try {
    http.Response response = await http.get(Uri.parse(feedURL));
    var feed;
    var feedType = "rss";
    try {
      feed = RssFeed.parse(response.body);
    } catch (e) {
      try {
        feed = AtomFeed.parse(response.body);
        feedType = "atom";
      } catch (e) {}
    }

    int newPostCount = 0;
    List<feedHistoryModel> newFeedList = [];
    try {
      for (int index = feed.items!.length - 1; index >= 0; index--) {
        final item = feed.items![index];
        
        bool isInFeed;
        if (feedType == "rss") {
        isInFeed = await DBProvider.db.isInFeedHistory(item.link as String);

        }
        else {
          isInFeed = await DBProvider.db.isInFeedHistory(item.links[0].href as String);
        }
        if (!isInFeed) {
          newPostCount++;
          var historyItem;
          if (feedType == "rss") {
            historyItem = feedHistoryModel(
                feedURL: feedURL,
                title: item.title ?? "",
                description: item.description ?? "",
                enclosure: item.enclosure?.url ?? "",
                url: item.link as String,
                isRead: "false",
                pubDate: item.pubDate?.toIso8601String() ?? "");
          } else {
            historyItem = feedHistoryModel(
                feedURL: feedURL,
                title: item.title ?? "",
                description: item.content ?? "",
                enclosure: "",
                url: item.links[0].href as String,
                isRead: "false",
                pubDate: item.updated?.toIso8601String() ?? "");
          }
          DBProvider.db.insertHistoryFeed(historyItem);
          newFeedList.add(historyItem);
        }
      }
    } catch (e) {
      rethrow;
    }

    return newFeedList;
  } catch (e) {
    rethrow;
  }
}

Future<String> fetchTitle(String feedURL) async {
  http.Response response = await http.get(Uri.parse(feedURL));

  try {
    final feed = RssFeed.parse(response.body);
    return feed.title as String;
  } catch (e) {}
  try {
    final feed = AtomFeed.parse(response.body);
    return feed.title as String;
  } catch (e) {}
  return "";
}
