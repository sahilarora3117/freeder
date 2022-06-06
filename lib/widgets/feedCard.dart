import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freeder/model/saveFeedModel.dart';
import '../network/WebView/webview.dart';
// ignore: depend_on_referenced_packages
import 'package:html/dom.dart' as dom;
import '../data/database.dart';


class feedCard extends StatefulWidget {
  late String title;
  late String pubDate;
  late String description;
  String url;
  late String enclosure;
  feedCard(
      {Key? key,
      required this.title,
      required this.pubDate,
      required this.enclosure,
      required this.description,
      required this.url})
      : super(key: key);

  @override
  State<feedCard> createState() => _feedCardState();
}

class _feedCardState extends State<feedCard> {

  bool isSaved= false;
  @override
  void initState() {
    super.initState();
    isSavedCheck(widget.url);

  }
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleComponent(context, widget.title),
          pubDateComponent(context, widget.pubDate),
          imageComponent(context, widget.enclosure),
          descriptionComponent(context, widget.description),
          bottomControls(context, widget.title, widget.pubDate, widget.description, widget.url, widget.enclosure),
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

  imageComponent(BuildContext context, String enclosure) {
    if (enclosure != "") {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
              image: NetworkImage(enclosure),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  titleComponent(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  pubDateComponent(BuildContext context, String pubDate) {
    if (pubDate != "") {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text(
          "Date posted: $pubDate",
          style: Theme.of(context).textTheme.titleSmall,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  descriptionComponent(BuildContext buildcontext, String description) {
    if (description != "") {
      return Html(
          data: description,
          onLinkTap: (String? url, RenderContext context,
              Map<String, String> attributes, dom.Element? element) {
            Navigator.push(
                buildcontext,
                MaterialPageRoute(
                    builder: (context) => WebViewExample(url: url as String)));
          });
    }
    ;
    return const SizedBox.shrink();
  }

  bottomControls(BuildContext context, String title, String pubDate, String description, String url, String enclosure) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        isFavouriteButton(title, pubDate, description, url, enclosure),
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebViewExample(url: url)));
          },
          icon: Icon(Icons.public),
        ),
        // isFavouriteButton(),
      ],
    );
  }

isFavouriteButton(String title, String pubDate, String description, String url, String enclosure) {
    if (!isSaved) {
      return IconButton(
        onPressed: () {
          
          var item = savedFeedModel(title: title, pubDate: pubDate, description: description, url: url, enclosure: enclosure);
          DBProvider.db.insertSaved(item);
          isSavedCheck(url);
        },
        tooltip: "Save post",
        icon: Icon(Icons.star),
      );
    }
    return IconButton(
      onPressed: () {
        DBProvider.db.removeSaved(url);
        isSavedCheck(url);
      },
      tooltip: "Remove from saved post",
      icon: Icon(Icons.star),
      color: Colors.yellow.shade800,

    );
  }
}
