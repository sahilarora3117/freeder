import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'data/database.dart';
import 'widgets/feedCard.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  List<favouriteListModel> favourites = [];
  String favouriteListstate = "ns";
  void initState() {
    super.initState();
    getFavourites();
  }

  getFavourites() async {
    List<favouriteListModel> localfav = await DBProvider.db.favorites();
    localfav = localfav.reversed.toList();
    setState(() {
      favourites = localfav;
      favouriteListstate = "st";
    });
  }
  favouriteList () {
    if (favourites.length == 0) {
      return Center(child: Text("No favourites found"),);
    } else {
      return ListView.builder(
        itemCount: favourites.length,
        itemBuilder: (BuildContext context, int index) {
          final item = favourites[index];
          return feedCard(
            title: item.title,
            pubDate: item.pubDate,
            enclosure: item.enclosure,
            description: item.description,
            url: item.url,
          );
        },
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
      ),
      body: Center(
        child: favouriteListstate == "ns" ? Center(child: CircularProgressIndicator(),) : favouriteList(),
      )
    );
  }
}
