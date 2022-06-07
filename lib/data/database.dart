import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/feedListModel.dart';
import '../model/saveFeedModel.dart';
import '../model/feedHistoryModel.dart';

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
          'CREATE TABLE saved(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, pubDate TEXT, description TEXT, url TEXT, enclosure TEXT)',
        );
        await db.execute(
          'CREATE TABLE listoffeed(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,feedName TEXT, feedURL TEXT)',
        );
        await db.execute(
          'CREATE TABLE feedhistory(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, feedURL TEXT , title TEXT, pubDate TEXT, description TEXT, url TEXT, enclosure TEXT, isRead TEXT)',
        );
      },
      version: 1,
    );
  }

  insertSaved(savedFeedModel saved) async {
    final db = await database;
    await db.insert(
      'saved',
      saved.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<savedFeedModel>> saved() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('saved');

    return List.generate(maps.length, (i) {
      return savedFeedModel(
        ID: maps[i]['ID'],
        title: maps[i]['title'],
        pubDate: maps[i]['pubDate'],
        description: maps[i]['description'],
        url: maps[i]['url'],
        enclosure: maps[i]['enclosure'],
      );
    });
  }

  Future<void> removeSaved(String url) async {
    final db = await database;
    await db.delete(
      'saved',
      where: 'url = ?',
      whereArgs: [url],
    );
  }

  Future<bool> isInSaved(String url) async {
    final db = await database;
    var queryResult =
        await db.rawQuery("SELECT * FROM saved WHERE url=\"$url\"");
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

  insertHistoryFeed(feedHistoryModel item) async {
    final db = await database;
    await db.insert(
      'feedhistory',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
