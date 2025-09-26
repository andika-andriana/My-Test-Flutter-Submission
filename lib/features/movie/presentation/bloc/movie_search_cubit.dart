import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieSearchCubit extends Cubit<ListState<Movie>> {
  MovieSearchCubit(this._searchMovies) : super(const ListState<Movie>());

  final SearchMovies _searchMovies;

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(const ListState<Movie>());
      return;
    }

    emit(state.copyWith(status: RequestState.loading));

    final result = await _searchMovies.execute(query);
    result.fold(
      (failure) => emit(
        state.copyWith(status: RequestState.error, message: failure.message),
      ),
      (movies) =>
          emit(state.copyWith(status: RequestState.loaded, items: movies)),
    );
  }
}
