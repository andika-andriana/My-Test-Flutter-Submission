import 'package:dartz/dartz.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/src/domain/entities/tv_series.dart';
import 'package:ditonton_tv_series/src/domain/repositories/tv_series_repository.dart';

class GetOnTheAirTVSeries {
  GetOnTheAirTVSeries(this.repository);

  final TVSeriesRepository repository;

  Future<Either<Failure, List<TVSeries>>> execute() {
    return repository.getOnTheAirTVSeries();
  }
}
