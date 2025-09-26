import 'package:ditonton_tv_series/src/domain/entities/tv_series.dart';
import 'package:ditonton_tv_series/src/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

class TVSeriesTable extends Equatable {
  const TVSeriesTable({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  });

  final int id;
  final String? name;
  final String? posterPath;
  final String? overview;

  factory TVSeriesTable.fromEntity(TVSeriesDetail tv) => TVSeriesTable(
    id: tv.id,
    name: tv.name,
    posterPath: tv.posterPath,
    overview: tv.overview,
  );

  factory TVSeriesTable.fromMap(Map<String, dynamic> map) => TVSeriesTable(
    id: map['id'],
    name: map['title'],
    posterPath: map['posterPath'],
    overview: map['overview'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': name,
    'posterPath': posterPath,
    'overview': overview,
  };

  TVSeries toEntity() => TVSeries.watchlist(
    id: id,
    overview: overview,
    posterPath: posterPath,
    name: name,
  );

  @override
  List<Object?> get props => [id, name, posterPath, overview];
}
