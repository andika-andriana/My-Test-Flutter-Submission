import 'package:ditonton_core/ditonton_core.dart';

import '../models/tv_series_table.dart';

abstract class TVSeriesLocalDataSource {
  Future<String> insertWatchlist(TVSeriesTable tvSeries);
  Future<String> removeWatchlist(TVSeriesTable tvSeries);
  Future<TVSeriesTable?> getTVSeriesById(int id);
  Future<List<TVSeriesTable>> getWatchlistTVSeries();
}

class TVSeriesLocalDataSourceImpl implements TVSeriesLocalDataSource {
  TVSeriesLocalDataSourceImpl({required this.databaseHelper});

  final DatabaseHelper databaseHelper;

  @override
  Future<String> insertWatchlist(TVSeriesTable tvSeries) async {
    try {
      await databaseHelper.insertTVWatchlist(tvSeries.toJson());
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TVSeriesTable tvSeries) async {
    try {
      await databaseHelper.removeTVWatchlist(tvSeries.id);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TVSeriesTable?> getTVSeriesById(int id) async {
    final result = await databaseHelper.getTVSeriesById(id);
    if (result != null) {
      return TVSeriesTable.fromMap(result);
    }
    return null;
  }

  @override
  Future<List<TVSeriesTable>> getWatchlistTVSeries() async {
    final result = await databaseHelper.getWatchlistTVSeries();
    return result.map((data) => TVSeriesTable.fromMap(data)).toList();
  }
}
