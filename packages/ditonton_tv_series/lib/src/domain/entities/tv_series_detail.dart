import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/src/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

class TVSeriesDetail extends Equatable {
  const TVSeriesDetail({
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.name,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.firstAirDate,
    required this.lastAirDate,
    required this.numberOfSeasons,
    required this.numberOfEpisodes,
    required this.episodeRunTime,
    required this.seasons,
    required this.homepage,
    required this.inProduction,
    required this.tagline,
  });

  final String? backdropPath;
  final List<Genre> genres;
  final int id;
  final String name;
  final String originalName;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final int voteCount;
  final String? firstAirDate;
  final String? lastAirDate;
  final int numberOfSeasons;
  final int numberOfEpisodes;
  final List<int> episodeRunTime;
  final List<Season> seasons;
  final String homepage;
  final bool inProduction;
  final String tagline;

  @override
  List<Object?> get props => [
    backdropPath,
    genres,
    id,
    name,
    originalName,
    overview,
    posterPath,
    voteAverage,
    voteCount,
    firstAirDate,
    lastAirDate,
    numberOfSeasons,
    numberOfEpisodes,
    episodeRunTime,
    seasons,
    homepage,
    inProduction,
    tagline,
  ];
}
