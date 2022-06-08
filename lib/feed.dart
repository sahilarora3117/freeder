import 'package:flutter/material.dart';
import 'package:freeder/data/database.dart';
import 'package:freeder/model/feedHistoryModel.dart';
import 'network/fetchFeed.dart';
import 'widgets/feedCard.dart';
import 'widgets/slideCard.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
  List<feedHistoryModel> _feed = [];
  
  void initState() {
    super.initState();
    load(widget.feedURL);
    _refresh();
  }

  load(String feedURL) async {
    setState(() {
      loadingState = "loading";
    });
    if (_feed == []) return;
    List<feedHistoryModel> localFeed =
        await DBProvider.db.fetchFeedHistory(feedURL);
    localFeed = localFeed.reversed.toList();

    setState(() {
      _feed = localFeed;
      loadingState = "loaded";
    });
  }

  Future<void> _refresh() async {
    try {
      int newPostCount = await fetchFeed(widget.feedURL);
      print(newPostCount);
      if (newPostCount > 0) {
        load(widget.feedURL);
      }
    } catch (e) {
      print(e);
    }
  }

  feedbody() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          itemCount: _feed.length,
          itemBuilder: (BuildContext context, int index) {
            final item = _feed[index];
            return Slidable(
              startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: 1,
                  children: [
                    slideCard(
                      title: item.title,
                      pubDate: item.pubDate,
                      enclosure: item.enclosure,
                      description: item.description,
                      url: item.url,
                    ),
                  ]),
              child: feedCard(
                title: item.title,
                pubDate: item.pubDate,
                enclosure: item.enclosure,
                description: item.description,
                url: item.url,
                isRead: item.isRead,
              ),
            );
          },
        ),
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
    } else if (_feed == []) {
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
                    load(widget.feedURL);
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
