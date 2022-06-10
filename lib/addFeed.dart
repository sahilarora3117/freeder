import 'package:flutter/material.dart';
import 'services/fetchFeed.dart';
import 'package:webfeed/webfeed.dart';
import 'data/database.dart';
import 'model/feedListModel.dart';

class addFeed extends StatefulWidget {
  const addFeed({Key? key}) : super(key: key);

  @override
  State<addFeed> createState() => _addFeedState();
}

class _addFeedState extends State<addFeed> {
  final _formKey = GlobalKey<FormState>();
  RssFeed _feed = RssFeed();

  checkFeedURL(String feedURL) {
    fetchTitle(feedURL).then((result) {
      setState(() {
        print(result);
        if (result == "") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Invalid feed provided')),
          );
          return;
        } else {
          var feed = feedListModelfinal(
              feedName: result, feedUrl: feedURL);
          DBProvider.db.insertFeed(feed);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: Colors.green, content: Text('Feed Added')),
          );
          return;
        }
      });
    });
  }

  final urlFieldController = TextEditingController();

  @override
  void dispose() {
    urlFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add feed"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Enter the url for the feed"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: urlFieldController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid URL';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    checkFeedURL(urlFieldController.text);
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
