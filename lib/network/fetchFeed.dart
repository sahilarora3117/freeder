import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:webfeed/webfeed.dart';

Future<RssFeed> fetchFeed(String feedURL) async {
  try {
  http.Response response = await http.get(Uri.parse(feedURL));
  return RssFeed.parse(response.body);
  }
  catch(e) {
    return RssFeed();
  }
  
}
