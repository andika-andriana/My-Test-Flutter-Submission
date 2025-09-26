import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/top_rated_tv_series_cubit.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetTopRatedTVSeries mockGetTopRatedTVSeries;
  late TopRatedTVSeriesCubit cubit;

  setUp(() {
    mockGetTopRatedTVSeries = MockGetTopRatedTVSeries();
    cubit = TopRatedTVSeriesCubit(mockGetTopRatedTVSeries);
  });

  tearDown(() => cubit.close());

  blocTest<TopRatedTVSeriesCubit, ListState<TVSeries>>(
    'emits [loading, loaded] when fetch succeeds',
    build: () {
      when(
        mockGetTopRatedTVSeries.execute(),
      ).thenAnswer((_) async => Right(testTVSeriesList));
      return cubit;
    },
    act: (cubit) => cubit.fetchTopRated(),
    expect: () => [
      ListState<TVSeries>(status: RequestState.loading),
      ListState<TVSeries>(status: RequestState.loaded, items: testTVSeriesList),
    ],
    verify: (_) {
      verify(mockGetTopRatedTVSeries.execute()).called(1);
    },
  );

  blocTest<TopRatedTVSeriesCubit, ListState<TVSeries>>(
    'emits [loading, error] when fetch fails',
    build: () {
      when(
        mockGetTopRatedTVSeries.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server failure')));
      return cubit;
    },
    act: (cubit) => cubit.fetchTopRated(),
    expect: () => const [
      ListState<TVSeries>(status: RequestState.loading),
      ListState<TVSeries>(
        status: RequestState.error,
        message: 'Server failure',
      ),
    ],
    verify: (_) {
      verify(mockGetTopRatedTVSeries.execute()).called(1);
    },
  );
}
