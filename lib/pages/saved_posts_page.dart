import 'package:flutter/material.dart';
import '../data/database.dart';
import '../widgets/feedCard.dart';
import '../model/saveFeedModel.dart';

class Saved extends StatefulWidget {
  const Saved({Key? key}) : super(key: key);

  @override
  State<Saved> createState() => _SavedsState();
}

class _SavedsState extends State<Saved> {
  List<savedFeedModel> saved= [];
  String savedListState = "ns";
  void initState() {
    super.initState();
    getSaved();
  }

  getSaved() async {
    List<savedFeedModel> localfav = await DBProvider.db.saved();
    localfav = localfav.reversed.toList();
    setState(() {
      saved = localfav;
      savedListState = "st";
    });
  }
  savedList () {
    if (saved.length == 0) {
      return Center(child: Text("No saved posts found"),);
    } else {
      return ListView.builder(
        itemCount: saved.length,
        itemBuilder: (BuildContext context, int index) {
          final item = saved[index];
          return feedCard(
            title: item.title,
            pubDate: item.pubDate,
            enclosure: item.enclosure,
            description: item.description,
            url: item.url,
            isRead: "false",
          );
        },
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Posts'),
      ),
      body: Center(
        child: savedListState == "ns" ? Center(child: CircularProgressIndicator(),) : savedList(),
      )
    );
  }
}
