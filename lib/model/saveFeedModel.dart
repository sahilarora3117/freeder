class savedFeedModel {
  int? ID;
  String title;
  String pubDate;
  String description;
  String url;
  String enclosure;
  savedFeedModel({
    this.ID,
    required this.title,
    required this.pubDate,
    required this.description,
    required this.url,
    required this.enclosure,
  });
  Map<String, dynamic> toMap() {
    return {
      'ID': ID,
      'title': title,
      'pubDate': pubDate,
      'description': description,
      'url': url,
      'enclosure': enclosure,
    };
  }
}