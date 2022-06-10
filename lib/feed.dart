import 'package:flutter/material.dart';
import 'package:freeder/data/database.dart';
import 'package:freeder/model/feedHistoryModel.dart';
import 'services/fetchFeed.dart';
import 'ui/shared/feedCard.dart';
import 'ui/shared/slideCard.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
  ItemScrollController _scrollController = ItemScrollController();
  int newPostCount = 0;
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
    int old_len = _feed.length;
    try {
      List<feedHistoryModel> localList = await fetchFeed(widget.feedURL);

      setState(() {
        newPostCount = localList.length;
        if (newPostCount > 0) {
          _feed = localList + _feed;
        }
      });
      print(newPostCount);
    } catch (e) {
      print(e);
    }
    jumpTofeed(old_len);
  }

  jumpTofeed(old_len) {
    print("jump to $newPostCount");
    if (old_len > 0) {
    _scrollController.jumpTo(index: newPostCount);

    }
  }

  feedbody() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: ScrollablePositionedList.builder(
          itemCount: _feed.length,
          itemScrollController: _scrollController,
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
