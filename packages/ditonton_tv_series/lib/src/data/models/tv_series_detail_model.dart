import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/src/data/models/season_model.dart';
import 'package:ditonton_tv_series/src/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

class TVSeriesDetailResponse extends Equatable {
  const TVSeriesDetailResponse({
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
  final List<GenreModel> genres;
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
  final List<SeasonModel> seasons;
  final String homepage;
  final bool inProduction;
  final String tagline;

  factory TVSeriesDetailResponse.fromJson(Map<String, dynamic> json) {
    return TVSeriesDetailResponse(
      backdropPath: json['backdrop_path'],
      genres: List<GenreModel>.from(
        (json['genres'] as List).map((x) => GenreModel.fromJson(x)),
      ),
      id: json['id'],
      name: json['name'],
      originalName: json['original_name'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'],
      firstAirDate: json['first_air_date'],
      lastAirDate: json['last_air_date'],
      numberOfSeasons: json['number_of_seasons'],
      numberOfEpisodes: json['number_of_episodes'],
      episodeRunTime: List<int>.from(
        (json['episode_run_time'] as List).map((x) => (x as num).toInt()),
      ),
      seasons: List<SeasonModel>.from(
        (json['seasons'] as List).map((x) => SeasonModel.fromJson(x)),
      ),
      homepage: json['homepage'] ?? '',
      inProduction: json['in_production'],
      tagline: json['tagline'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'backdrop_path': backdropPath,
    'genres': List<dynamic>.from(genres.map((x) => x.toJson())),
    'id': id,
    'name': name,
    'original_name': originalName,
    'overview': overview,
    'poster_path': posterPath,
    'vote_average': voteAverage,
    'vote_count': voteCount,
    'first_air_date': firstAirDate,
    'last_air_date': lastAirDate,
    'number_of_seasons': numberOfSeasons,
    'number_of_episodes': numberOfEpisodes,
    'episode_run_time': List<dynamic>.from(episodeRunTime.map((x) => x)),
    'seasons': List<dynamic>.from(seasons.map((x) => x.toJson())),
    'homepage': homepage,
    'in_production': inProduction,
    'tagline': tagline,
  };

  TVSeriesDetail toEntity() => TVSeriesDetail(
    backdropPath: backdropPath,
    genres: genres.map((e) => e.toEntity()).toList(),
    id: id,
    name: name,
    originalName: originalName,
    overview: overview,
    posterPath: posterPath,
    voteAverage: voteAverage,
    voteCount: voteCount,
    firstAirDate: firstAirDate,
    lastAirDate: lastAirDate,
    numberOfSeasons: numberOfSeasons,
    numberOfEpisodes: numberOfEpisodes,
    episodeRunTime: episodeRunTime,
    seasons: seasons.map((e) => e.toEntity()).toList(),
    homepage: homepage,
    inProduction: inProduction,
    tagline: tagline,
  );

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
