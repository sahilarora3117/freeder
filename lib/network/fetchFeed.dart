import 'dart:async';
import 'package:http/http.dart' as http;
import '../data/database.dart';
import 'package:webfeed/webfeed.dart';
import '../model/feedHistoryModel.dart';

Future<RssFeed> fetchFeed(String feedURL) async {
  try {
    http.Response response = await http.get(Uri.parse(feedURL));
    final feed = RssFeed.parse(response.body);
    int count = 0;

    try {
      for (int index = 0; index < feed.items!.length; index++) {
        final item = feed.items![index];
        bool isInFeed =
            await DBProvider.db.isInFeedHistory(item.link as String);
        if (!isInFeed) {
          count++;
          var historyItem = feedHistoryModel(
              feedURL: feedURL,
              title: item.title ?? "",
              description: item.description ?? "",
              enclosure: item.enclosure?.url ?? "",
              url: item.link as String,
              isRead: "false",
              pubDate: item.pubDate?.toIso8601String()??"" as String);
          DBProvider.db.insertHistoryFeed(historyItem);
        }
      }
    } catch (e) {
      throw(e);
    }

    return RssFeed.parse(response.body);
  } catch (e) {
    return RssFeed();
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
