class feedListModelfinal {
  int? ID;
  String feedName;
  String feedUrl;
  feedListModelfinal({this.ID, required this.feedName, required this.feedUrl});

  Map<String, dynamic> toMap() {
    return {
      'ID': ID,
      'feedName': feedName,
      'feedUrl': feedUrl,
    };
  }
}
