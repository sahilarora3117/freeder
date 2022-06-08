import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freeder/model/saveFeedModel.dart';
import 'package:url_launcher/url_launcher.dart';
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
  late String isRead;
  feedCard(
      {Key? key,
      required this.title,
      required this.pubDate,
      required this.enclosure,
      required this.description,
      required this.url,
      required this.isRead})
      : super(key: key);

  @override
  State<feedCard> createState() => _feedCardState();
}

class _feedCardState extends State<feedCard> {
  late String isRead;
  @override
  void initState() {
    super.initState();
    setState(() {
      isRead = widget.isRead;
    });
  }

  void _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication))
      throw 'Could not launch';
  }

  Widget build(BuildContext context) {
    void toggleRead(url) async {
      int count = await DBProvider.db.toggleRead(url);
    }

    return InkWell(
      onTap: () {
        if (isRead == "false") {
          DBProvider.db.toggleRead(widget.url);
        }
        setState(() {
          isRead = "true";
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewExample(url: widget.url)));
      },
      child: (isRead == "false")
          ? Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleComponent(context, widget.title),
                  pubDateComponent(context, widget.pubDate),
                  imageComponent(context, widget.enclosure),
                  descriptionComponent(context, widget.description),
                ],
              ),
            )
          : Opacity(
              opacity: 0.6,
              child: Card(
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleComponent(context, widget.title),
                    pubDateComponent(context, widget.pubDate),
                    imageComponent(context, widget.enclosure),
                    descriptionComponent(context, widget.description),
                  ],
                ),
              ),
            ),
    );
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

  bottomControls(BuildContext context, String title, String pubDate,
      String description, String url, String enclosure) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          tooltip: "Open in browser",
          onPressed: () {
            _launchUrl(url);
          },
          icon: Icon(Icons.public),
        ),
      ],
    );
  }
}
