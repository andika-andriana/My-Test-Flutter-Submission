import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesCubit extends Cubit<ListState<Movie>> {
  PopularMoviesCubit(this._getPopularMovies) : super(const ListState<Movie>());

  final GetPopularMovies _getPopularMovies;

  Future<void> fetchPopular() async {
    emit(state.copyWith(status: RequestState.loading));

    final result = await _getPopularMovies.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(status: RequestState.error, message: failure.message),
      ),
      (movies) =>
          emit(state.copyWith(status: RequestState.loaded, items: movies)),
    );
  }
}
