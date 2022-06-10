import 'package:flutter/material.dart';
import '../../feed.dart';
import 'add_feed_page.dart';
import 'settings_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'saved_posts_page.dart';
import '../../data/database.dart';
import '../../model/feedListModel.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<feedListModelfinal> feedList = [];
  String feedListState = "ns";
  getList() async {
    setState(() {
      feedListState = "ns";
    });
    List<feedListModelfinal> localFeed = await DBProvider.db.feeds();
    setState(() {
      feedList = localFeed;
      feedListState = "st";
    });
  }

  void initState() {
    super.initState();
    getList();
  }

  void urlLaunch(url) async {
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Freeder'),
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Saved(),
                  ),
                );
              },
              child: const Icon(Icons.star),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const settings(),
                  ),
                );
              },
              child: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: (feedListState == "ns")
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : feedList.isEmpty
              ? const Center(
                  child:
                      Text('The feed list is empty click on "+" to add feeds.'),
                )
              : ListView(
                  children: [
                    for (int i = 0; i < feedList.length; i++)
                      feedTile(i, context),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => addFeed(),
            ),
          ).whenComplete(
            () => getList(),
          );
        },
        tooltip: "Add Feed",
        child: Icon(Icons.add),
      ),
    );
    // }
  }

  ListTile feedTile(int i, BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.album, size: 50),
      title: Text(feedList[i].feedName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.delete, size: 25),
            onPressed: () async {
              await DBProvider.db.deleteFeed(feedList[i].ID as int);
              getList();
            },
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Feed(
              feedTitle: feedList[i].feedName,
              feedURL: feedList[i].feedUrl,
            ),
          ),
        );
      },
    );
  }
}
