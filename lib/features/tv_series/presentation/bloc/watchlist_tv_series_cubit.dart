import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTVSeriesCubit extends Cubit<ListState<TVSeries>> {
  WatchlistTVSeriesCubit(this._getWatchlistTVSeries)
    : super(const ListState<TVSeries>());

  final GetWatchlistTVSeries _getWatchlistTVSeries;

  Future<void> fetchWatchlist() async {
    emit(state.copyWith(status: RequestState.loading));

    final result = await _getWatchlistTVSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(status: RequestState.error, message: failure.message),
      ),
      (tvSeries) =>
          emit(state.copyWith(status: RequestState.loaded, items: tvSeries)),
    );
  }
}
