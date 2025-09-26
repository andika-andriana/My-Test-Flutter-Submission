import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TVSeriesDetailState extends Equatable {
  const TVSeriesDetailState({
    this.status = RequestState.empty,
    this.recommendationsStatus = RequestState.empty,
    this.tvSeries,
    this.recommendations = const [],
    this.isInWatchlist = false,
    this.message = '',
    this.watchlistMessage = '',
  });

  final RequestState status;
  final RequestState recommendationsStatus;
  final TVSeriesDetail? tvSeries;
  final List<TVSeries> recommendations;
  final bool isInWatchlist;
  final String message;
  final String watchlistMessage;

  TVSeriesDetailState copyWith({
    RequestState? status,
    RequestState? recommendationsStatus,
    TVSeriesDetail? tvSeries,
    List<TVSeries>? recommendations,
    bool? isInWatchlist,
    String? message,
    String? watchlistMessage,
  }) {
    return TVSeriesDetailState(
      status: status ?? this.status,
      recommendationsStatus:
          recommendationsStatus ?? this.recommendationsStatus,
      tvSeries: tvSeries ?? this.tvSeries,
      recommendations: recommendations ?? this.recommendations,
      isInWatchlist: isInWatchlist ?? this.isInWatchlist,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    recommendationsStatus,
    tvSeries,
    recommendations,
    isInWatchlist,
    message,
    watchlistMessage,
  ];
}

class TVSeriesDetailCubit extends Cubit<TVSeriesDetailState> {
  TVSeriesDetailCubit(
    this._getTVSeriesDetail,
    this._getTVSeriesRecommendations,
    this._getWatchlistStatus,
    this._saveWatchlist,
    this._removeWatchlist,
  ) : super(const TVSeriesDetailState());

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTVSeriesDetail _getTVSeriesDetail;
  final GetTVSeriesRecommendations _getTVSeriesRecommendations;
  final GetTVWatchlistStatus _getWatchlistStatus;
  final SaveTVWatchlist _saveWatchlist;
  final RemoveTVWatchlist _removeWatchlist;

  Future<void> fetchDetail(int id) async {
    emit(state.copyWith(status: RequestState.loading, message: ''));

    final detailResult = await _getTVSeriesDetail.execute(id);
    await detailResult.fold(
      (failure) async {
        emit(
          state.copyWith(status: RequestState.error, message: failure.message),
        );
      },
      (tvSeries) async {
        emit(
          state.copyWith(
            status: RequestState.loaded,
            tvSeries: tvSeries,
            message: '',
          ),
        );

        emit(state.copyWith(recommendationsStatus: RequestState.loading));

        final recommendationResult = await _getTVSeriesRecommendations.execute(
          id,
        );
        recommendationResult.fold(
          (failure) => emit(
            state.copyWith(
              recommendationsStatus: RequestState.error,
              message: failure.message,
            ),
          ),
          (tvSeriesList) => emit(
            state.copyWith(
              recommendationsStatus: RequestState.loaded,
              recommendations: tvSeriesList,
            ),
          ),
        );
      },
    );
  }

  Future<void> loadWatchlistStatus(int id) async {
    final status = await _getWatchlistStatus.execute(id);
    emit(state.copyWith(isInWatchlist: status));
  }

  Future<void> addToWatchlist(TVSeriesDetail tvSeriesDetail) async {
    final result = await _saveWatchlist.execute(tvSeriesDetail);
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (successMessage) => emit(
        state.copyWith(watchlistMessage: successMessage, isInWatchlist: true),
      ),
    );
  }

  Future<void> removeFromWatchlist(TVSeriesDetail tvSeriesDetail) async {
    final result = await _removeWatchlist.execute(tvSeriesDetail);
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (successMessage) => emit(
        state.copyWith(watchlistMessage: successMessage, isInWatchlist: false),
      ),
    );
  }
}
