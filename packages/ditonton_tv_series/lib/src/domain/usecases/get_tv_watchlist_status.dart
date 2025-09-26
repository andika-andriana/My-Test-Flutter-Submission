import 'package:ditonton_tv_series/src/domain/repositories/tv_series_repository.dart';

class GetTVWatchlistStatus {
  GetTVWatchlistStatus(this.repository);

  final TVSeriesRepository repository;

  Future<bool> execute(int id) {
    return repository.isAddedToWatchlist(id);
  }
}
