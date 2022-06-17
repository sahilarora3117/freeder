import 'package:flutter/material.dart';
import 'package:freeder/model/feedHistoryModel.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:freeder/ui/shared/post/feedCard.dart';
import 'package:freeder/ui/shared/slideCard.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedMain extends StatelessWidget {
  final List<feedHistoryModel> feed;
  final VoidCallback refresh;
  final String feedURL;
  final ItemScrollController controller;
  const FeedMain({Key? key, required this.feed, required this.refresh, required this.feedURL, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Future<void> onRefresh() async {
      refresh();
    };
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: ScrollablePositionedList.builder(
          itemCount: feed.length,
          itemScrollController: controller,
          itemBuilder: (BuildContext context, int index) {
            final item = feed[index];
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
                pubDate: timeago.format(DateTime.parse(item.pubDate)),
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
}