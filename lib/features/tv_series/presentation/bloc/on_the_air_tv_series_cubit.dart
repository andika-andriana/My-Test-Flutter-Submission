import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnTheAirTVSeriesCubit extends Cubit<ListState<TVSeries>> {
  OnTheAirTVSeriesCubit(this._getOnTheAirTVSeries)
    : super(const ListState<TVSeries>());

  final GetOnTheAirTVSeries _getOnTheAirTVSeries;

  Future<void> fetchOnTheAir() async {
    emit(state.copyWith(status: RequestState.loading));

    final result = await _getOnTheAirTVSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(status: RequestState.error, message: failure.message),
      ),
      (tvSeries) =>
          emit(state.copyWith(status: RequestState.loaded, items: tvSeries)),
    );
  }
}
