import 'dart:async';
import 'package:http/http.dart' as http;
import '../data/database.dart';
import 'package:webfeed/webfeed.dart';
import '../model/feedHistoryModel.dart';

Future<int> fetchFeed(String feedURL) async {
  try {
    http.Response response = await http.get(Uri.parse(feedURL));
    final feed = RssFeed.parse(response.body);
    int newPostCount = 0;

    try {
      for (int index = feed.items!.length - 1; index >= 0; index--) {
        final item = feed.items![index];
        bool isInFeed =
            await DBProvider.db.isInFeedHistory(item.link as String);
        if (!isInFeed) {
          newPostCount++;
          var historyItem = feedHistoryModel(
              feedURL: feedURL,
              title: item.title ?? "",
              description: item.description ?? "",
              enclosure: item.enclosure?.url ?? "",
              url: item.link as String,
              isRead: "false",
              pubDate: item.pubDate?.toIso8601String()??"");
          DBProvider.db.insertHistoryFeed(historyItem);
        }
      }
    } catch (e) {
      rethrow;
    }

    return newPostCount;
  } catch (e) {
    rethrow;
  }
}

Future<String> fetchTitle(String feedURL) async {
  try {
    http.Response response = await http.get(Uri.parse(feedURL));
    final feed = RssFeed.parse(response.body);
    return feed.title as String;
  } catch (e) {
    return "";
  }
}
