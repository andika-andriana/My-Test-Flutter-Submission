import 'dart:async';

import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblWatchlist = 'watchlist';
  static const String _tblTVWatchlist = 'tvWatchlist';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    var db = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
      onOpen: (db) async {
        await _createTVWatchlistTable(db);
      },
    );
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
    await _createTVWatchlistTable(db);
  }

  Future<void> _createTVWatchlistTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tblTVWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  Future<int> insertWatchlist(Map<String, dynamic> movie) async {
    final db = await database;
    return await db!.insert(_tblWatchlist, movie);
  }

  Future<int> removeWatchlist(int id) async {
    final db = await database;
    return await db!.delete(_tblWatchlist, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblWatchlist);

    return results;
  }

  Future<int> insertTVWatchlist(Map<String, dynamic> tv) async {
    final db = await database;
    return await db!.insert(_tblTVWatchlist, tv);
  }

  Future<int> removeTVWatchlist(int id) async {
    final db = await database;
    return await db!.delete(_tblTVWatchlist, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getTVSeriesById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblTVWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistTVSeries() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblTVWatchlist);

    return results;
  }
}
