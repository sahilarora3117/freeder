//ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, feedURL TEXT , title TEXT, pubDate TEXT, description TEXT, url TEXT, enclosure TEXT, isRead TEXT
class feedHistoryModel {
  int? ID;
  String feedURL;
  String title;
  String pubDate;
  String description;
  String url;
  String enclosure;
  String isRead;

  //feedHistoryModel Constructor
  feedHistoryModel({
    this.ID,
    required this.feedURL,
    required this.title,
    required this.pubDate,
    required this.description,
    required this.url,
    required this.enclosure,
    required this.isRead,
  });

  //FeedHistoryModel map function
  Map<String, dynamic> toMap() {
    return {
      'ID': ID,
      'feedURL': feedURL,
      'title': title,
      'pubDate': pubDate,
      'description': description,
      'url': url,
      'enclosure': enclosure,
      'isRead': isRead,
    };
  }
}
