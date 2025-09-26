import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NowPlayingMoviesCubit extends Cubit<ListState<Movie>> {
  NowPlayingMoviesCubit(this._getNowPlayingMovies)
    : super(const ListState<Movie>());

  final GetNowPlayingMovies _getNowPlayingMovies;

  Future<void> fetchNowPlaying() async {
    emit(state.copyWith(status: RequestState.loading));

    final result = await _getNowPlayingMovies.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(status: RequestState.error, message: failure.message),
      ),
      (movies) =>
          emit(state.copyWith(status: RequestState.loaded, items: movies)),
    );
  }
}
