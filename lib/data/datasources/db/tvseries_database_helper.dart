import 'dart:async';

import 'package:ditonton/data/models/tvseries_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperTv {
  static DatabaseHelperTv? _databaseHelperTv;
  DatabaseHelperTv._instance() {
    _databaseHelperTv = this;
  }

  factory DatabaseHelperTv() =>
      _databaseHelperTv ?? DatabaseHelperTv._instance();

  static Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initDb();
    }
    return _database;
  }

  static const String _tblWatchlist = 'watchlistTv';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/tvseries.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblWatchlist (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  Future<int> insertWatchlistTvSeries(TvSeriesTable tvseries) async {
    final db = await database;
    return await db!.insert(_tblWatchlist, tvseries.toJson());
  }

  Future<int> removeWatchlistTvSeries(TvSeriesTable tvseries) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [tvseries.id],
    );
  }

  Future<Map<String, dynamic>?> getTvSeriesById(int id) async {
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

  Future<List<Map<String, dynamic>>> getWatchlistTvSeries() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblWatchlist);

    return results;
  }
}
