import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/watchlist_tv_series_cubit.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetWatchlistTVSeries mockGetWatchlistTVSeries;
  late WatchlistTVSeriesCubit cubit;

  setUp(() {
    mockGetWatchlistTVSeries = MockGetWatchlistTVSeries();
    cubit = WatchlistTVSeriesCubit(mockGetWatchlistTVSeries);
  });

  tearDown(() => cubit.close());

  blocTest<WatchlistTVSeriesCubit, ListState<TVSeries>>(
    'emits [loading, loaded] when watchlist fetched successfully',
    build: () {
      when(
        mockGetWatchlistTVSeries.execute(),
      ).thenAnswer((_) async => Right(testTVSeriesList));
      return cubit;
    },
    act: (cubit) => cubit.fetchWatchlist(),
    expect: () => [
      ListState<TVSeries>(status: RequestState.loading),
      ListState<TVSeries>(status: RequestState.loaded, items: testTVSeriesList),
    ],
    verify: (_) {
      verify(mockGetWatchlistTVSeries.execute()).called(1);
    },
  );

  blocTest<WatchlistTVSeriesCubit, ListState<TVSeries>>(
    'emits [loading, error] when watchlist fetch fails',
    build: () {
      when(mockGetWatchlistTVSeries.execute()).thenAnswer(
        (_) async => const Left(DatabaseFailure('Database failure')),
      );
      return cubit;
    },
    act: (cubit) => cubit.fetchWatchlist(),
    expect: () => const [
      ListState<TVSeries>(status: RequestState.loading),
      ListState<TVSeries>(
        status: RequestState.error,
        message: 'Database failure',
      ),
    ],
    verify: (_) {
      verify(mockGetWatchlistTVSeries.execute()).called(1);
    },
  );
}
