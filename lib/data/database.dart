import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database> get database async => _database ??= await initDB();
  

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'feeds.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE favourites(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, pubDate TEXT, description TEXT, url TEXT, enclosure TEXT)',
        );
        await db.execute(
          'CREATE TABLE listoffeed(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,feedName TEXT, feedURL TEXT)',
        );
      },
      version: 1,
    );
  }

  insertFavourites(favouriteListModel favorite) async {
    final db = await database;
    await db.insert(
      'favourites',
      favorite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<favouriteListModel>> favorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favourites');

    return List.generate(maps.length, (i) {
      return favouriteListModel(
        ID: maps[i]['ID'],
        title: maps[i]['title'],
        pubDate: maps[i]['pubDate'],
        description: maps[i]['description'],
        url: maps[i]['url'],
        enclosure: maps[i]['enclosure'],
      );
    });
  }

  Future<void> removeFavourites(String url) async {
    final db = await database;
    await db.delete(
      'favourites',
      where: 'url = ?',
      whereArgs: [url],
    );
  }

  Future<bool> isInFavourites(String url) async {
    final db = await database;
    var queryResult =
        await db.rawQuery("SELECT * FROM favourites WHERE url=\"$url\"");
    if (queryResult.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  insertFeed(feedListModelfinal feed) async {
    final db = await database;
    await db.insert(
      'listoffeed',
      feed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // get the feed list
  Future<List<feedListModelfinal>> feeds() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('listoffeed');

    return List.generate(maps.length, (i) {
      return feedListModelfinal(
        ID: maps[i]['ID'],
        feedName: maps[i]['feedName'],
        feedUrl: maps[i]['feedURL'],
      );
    });
  }

  // delete from a feed list
  Future<void> deleteFeed(int id) async {
    final db = await database;

    await db.delete(
      'listoffeed',
      where: 'ID = ?',
      whereArgs: [id],
    );
  }
}

class favouriteListModel {
  int? ID;
  String title;
  String pubDate;
  String description;
  String url;
  String enclosure;
  favouriteListModel({
    this.ID,
    required this.title,
    required this.pubDate,
    required this.description,
    required this.url,
    required this.enclosure,
  });
  Map<String, dynamic> toMap() {
    return {
      'ID': ID,
      'title': title,
      'pubDate': pubDate,
      'description': description,
      'url': url,
      'enclosure': enclosure,
    };
  }
}

class feedListModelfinal {
  int? ID;
  String feedName;
  String feedUrl;
  feedListModelfinal({this.ID, required this.feedName, required this.feedUrl});

  Map<String, dynamic> toMap() {
    return {
      'ID': ID,
      'feedName': feedName,
      'feedUrl': feedUrl,
    };
  }
}
