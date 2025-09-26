import 'package:ditonton_tv_series/src/data/models/tv_series_model.dart';
import 'package:equatable/equatable.dart';

class TVSeriesResponse extends Equatable {
  const TVSeriesResponse({required this.tvSeriesList});

  final List<TVSeriesModel> tvSeriesList;

  factory TVSeriesResponse.fromJson(Map<String, dynamic> json) =>
      TVSeriesResponse(
        tvSeriesList: List<TVSeriesModel>.from(
          (json['results'] as List)
              .map((x) => TVSeriesModel.fromJson(x))
              .where((element) => element.posterPath != null),
        ),
      );

  Map<String, dynamic> toJson() => {
    'results': List<dynamic>.from(tvSeriesList.map((x) => x.toJson())),
  };

  @override
  List<Object?> get props => [tvSeriesList];
}
