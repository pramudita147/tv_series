import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/tvseries_database_helper.dart';
import 'package:ditonton/data/models/tvseries_table.dart';

abstract class TvSeriesLocalDataSource {
  Future<String> insertWatchlistTvSeries(TvSeriesTable tvseries);
  Future<String> removeWatchlistTvSeries(TvSeriesTable tvseries);
  Future<TvSeriesTable?> getTvSeriesById(int id);
  Future<List<TvSeriesTable>> getWatchlistTvSeries();
}

class TvSeriesLocalDataSourceImpl implements TvSeriesLocalDataSource {
  final DatabaseHelperTv databaseHelperTv;

  TvSeriesLocalDataSourceImpl({required this.databaseHelperTv});

  @override
  Future<String> insertWatchlistTvSeries(TvSeriesTable tvseries) async {
    try {
      await databaseHelperTv.insertWatchlistTvSeries(tvseries);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlistTvSeries(TvSeriesTable tvseries) async {
    try {
      await databaseHelperTv.removeWatchlistTvSeries(tvseries);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvSeriesTable?> getTvSeriesById(int id) async {
    final result = await databaseHelperTv.getTvSeriesById(id);
    if (result != null) {
      return TvSeriesTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvSeriesTable>> getWatchlistTvSeries() async {
    final result = await databaseHelperTv.getWatchlistTvSeries();
    return result.map((data) => TvSeriesTable.fromMap(data)).toList();
  }
}
