import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'network/fetchFeed.dart';
import 'package:intl/intl.dart';
import 'widgets/feedCard.dart';

class Feed extends StatefulWidget {
  final String feedTitle;
  final String feedURL;
  const Feed({
    Key? key,
    required this.feedTitle,
    required this.feedURL,
  }) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  String loadingState = "loading";
  RssFeed _feed = RssFeed();
  void initState() {
    super.initState();
    load();
  }

  load() async {
    setState(() {
      loadingState = "loading";
    });
    if (_feed == RssFeed()) return;
    fetchFeed(widget.feedURL).then((result) {
      updateFeed(result);
    });
  }

  updateFeed(result) {
    _feed = result;
    setState(() {
      loadingState = "loaded";
    });
  }

  feedbody() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        itemCount: _feed.items!.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _feed.items![index];
          String pubDate = "";
          String description = "";
          String enclosure = "";
          try {
            pubDate = DateFormat('yMd').format(item.pubDate as DateTime);
          } catch (e) {
            pubDate = "";
          }
          try {
            description = item.description as String;
          } catch (e) {
            description = "";
          }
          try {
            enclosure = item.enclosure?.url as String;
          } catch (e) {
            enclosure = "";
          }
          return feedCard(
            title: item.title as String,
            pubDate: pubDate,
            enclosure: enclosure,
            description: description,
            url: item.link as String,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loadingState == "loading") {
      return Scaffold(
          appBar: AppBar(title: Text(widget.feedTitle)),
          body: const Center(
            child: CircularProgressIndicator(),
          ));
    } else if (_feed.items == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.feedTitle)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("An Error occured while loading this feed"),
              )),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    load();
                  },
                  child: const Text('Refresh'),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: ((context, innerBoxIsScrolled) => [
                SliverAppBar(
                  floating: true,
                  title: Text(widget.feedTitle),
                  snap: true,
                )
              ]),
          body: feedbody(),
        ),
      );
    }
  }
}
