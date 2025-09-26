import 'package:dartz/dartz.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/src/domain/entities/tv_series_detail.dart';
import 'package:ditonton_tv_series/src/domain/repositories/tv_series_repository.dart';

class GetTVSeriesDetail {
  GetTVSeriesDetail(this.repository);

  final TVSeriesRepository repository;

  Future<Either<Failure, TVSeriesDetail>> execute(int id) {
    return repository.getTVSeriesDetail(id);
  }
}
