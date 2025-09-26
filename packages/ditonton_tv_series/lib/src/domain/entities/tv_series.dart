import 'package:equatable/equatable.dart';

class TVSeries extends Equatable {
  const TVSeries({
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.firstAirDate,
  });

  const TVSeries.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.name,
  }) : backdropPath = null,
       genreIds = null,
       originCountry = null,
       originalLanguage = null,
       originalName = null,
       popularity = null,
       voteAverage = null,
       voteCount = null,
       firstAirDate = null;

  final String? backdropPath;
  final List<int>? genreIds;
  final int id;
  final String? name;
  final List<String>? originCountry;
  final String? originalLanguage;
  final String? originalName;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final double? voteAverage;
  final int? voteCount;
  final String? firstAirDate;

  @override
  List<Object?> get props => [
    backdropPath,
    genreIds,
    id,
    name,
    originCountry,
    originalLanguage,
    originalName,
    overview,
    popularity,
    posterPath,
    voteAverage,
    voteCount,
    firstAirDate,
  ];
}
