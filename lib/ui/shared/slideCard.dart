import 'package:flutter/material.dart';
import '../../model/saveFeedModel.dart';
import '../../data/database.dart';
import '../../utils/utils.dart';

class slideCard extends StatefulWidget {
  final String title;
  final String pubDate;
  final String description;
  final String url;
  final String enclosure;
  const slideCard(
      {Key? key,
      required this.title,
      required this.pubDate,
      required this.enclosure,
      required this.description,
      required this.url,})
      : super(key: key);

  @override
  State<slideCard> createState() => _slideCardState();
}

class _slideCardState extends State<slideCard> {
  bool isSaved = false ;

  @override
  void initState() {
    super.initState();
    isSavedCheck(widget.url);
  }

  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isSavedButton(widget.title, widget.pubDate, widget.description,
                  widget.url, widget.enclosure)
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  launchInBrowser(widget.url);
                },
                icon: Icon(Icons.public_outlined),
              ),
              Text('Open')
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.remove_red_eye),
              ),
              Text('Mark Read')
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  shareURL(widget.title, widget.url);
                },
                icon: Icon(Icons.share_outlined),
              ),
              Text('Share')
            ],
          ),
        ],
      ),
    );
  }

  isSavedCheck(url) async {
    bool check = await DBProvider.db.isInSaved(url);
    setState(() {
      isSaved = check;
    });
  }

  isSavedButton(String title, String pubDate, String description, String url,
      String enclosure) {
    if (!isSaved) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              var item = savedFeedModel(
                  title: title,
                  pubDate: pubDate,
                  description: description,
                  url: url,
                  enclosure: enclosure);
              DBProvider.db.insertSaved(item);
              isSavedCheck(url);
            },
            tooltip: "Save post",
            icon: Icon(Icons.star_outline),
          ),
          Text("Save"),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            DBProvider.db.removeSaved(url);
            isSavedCheck(url);
          },
          tooltip: "Remove from saved post",
          icon: Icon(Icons.star),
          color: Colors.yellow,
        ),
        Text('Unsave'),
      ],
    );
  }
}
