import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailState extends Equatable {
  const MovieDetailState({
    this.status = RequestState.empty,
    this.recommendationsStatus = RequestState.empty,
    this.movie,
    this.recommendations = const [],
    this.isInWatchlist = false,
    this.message = '',
    this.watchlistMessage = '',
  });

  final RequestState status;
  final RequestState recommendationsStatus;
  final MovieDetail? movie;
  final List<Movie> recommendations;
  final bool isInWatchlist;
  final String message;
  final String watchlistMessage;

  MovieDetailState copyWith({
    RequestState? status,
    RequestState? recommendationsStatus,
    MovieDetail? movie,
    List<Movie>? recommendations,
    bool? isInWatchlist,
    String? message,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      status: status ?? this.status,
      recommendationsStatus:
          recommendationsStatus ?? this.recommendationsStatus,
      movie: movie ?? this.movie,
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
    movie,
    recommendations,
    isInWatchlist,
    message,
    watchlistMessage,
  ];
}

class MovieDetailCubit extends Cubit<MovieDetailState> {
  MovieDetailCubit(
    this._getMovieDetail,
    this._getMovieRecommendations,
    this._getWatchListStatus,
    this._saveWatchlist,
    this._removeWatchlist,
  ) : super(const MovieDetailState());

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail _getMovieDetail;
  final GetMovieRecommendations _getMovieRecommendations;
  final GetWatchListStatus _getWatchListStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;

  Future<void> fetchDetail(int id) async {
    emit(state.copyWith(status: RequestState.loading, message: ''));

    final detailResult = await _getMovieDetail.execute(id);
    await detailResult.fold(
      (failure) async {
        emit(
          state.copyWith(status: RequestState.error, message: failure.message),
        );
      },
      (movie) async {
        emit(
          state.copyWith(
            status: RequestState.loaded,
            movie: movie,
            message: '',
          ),
        );

        emit(state.copyWith(recommendationsStatus: RequestState.loading));

        final recommendationResult = await _getMovieRecommendations.execute(id);
        recommendationResult.fold(
          (failure) => emit(
            state.copyWith(
              recommendationsStatus: RequestState.error,
              message: failure.message,
            ),
          ),
          (movies) => emit(
            state.copyWith(
              recommendationsStatus: RequestState.loaded,
              recommendations: movies,
            ),
          ),
        );
      },
    );
  }

  Future<void> loadWatchlistStatus(int id) async {
    final status = await _getWatchListStatus.execute(id);
    emit(state.copyWith(isInWatchlist: status));
  }

  Future<void> addToWatchlist(MovieDetail movie) async {
    final result = await _saveWatchlist.execute(movie);
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (successMessage) => emit(
        state.copyWith(watchlistMessage: successMessage, isInWatchlist: true),
      ),
    );
  }

  Future<void> removeFromWatchlist(MovieDetail movie) async {
    final result = await _removeWatchlist.execute(movie);
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (successMessage) => emit(
        state.copyWith(watchlistMessage: successMessage, isInWatchlist: false),
      ),
    );
  }
}
