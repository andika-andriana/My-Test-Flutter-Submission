import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/on_the_air_tv_series_cubit.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetOnTheAirTVSeries mockGetOnTheAirTVSeries;
  late OnTheAirTVSeriesCubit cubit;

  setUp(() {
    mockGetOnTheAirTVSeries = MockGetOnTheAirTVSeries();
    cubit = OnTheAirTVSeriesCubit(mockGetOnTheAirTVSeries);
  });

  tearDown(() => cubit.close());

  blocTest<OnTheAirTVSeriesCubit, ListState<TVSeries>>(
    'emits [loading, loaded] when data fetched successfully',
    build: () {
      when(
        mockGetOnTheAirTVSeries.execute(),
      ).thenAnswer((_) async => Right(testTVSeriesList));
      return cubit;
    },
    act: (cubit) => cubit.fetchOnTheAir(),
    expect: () => [
      ListState<TVSeries>(status: RequestState.loading),
      ListState<TVSeries>(status: RequestState.loaded, items: testTVSeriesList),
    ],
    verify: (_) {
      verify(mockGetOnTheAirTVSeries.execute()).called(1);
    },
  );

  blocTest<OnTheAirTVSeriesCubit, ListState<TVSeries>>(
    'emits [loading, error] when fetch fails',
    build: () {
      when(
        mockGetOnTheAirTVSeries.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server failure')));
      return cubit;
    },
    act: (cubit) => cubit.fetchOnTheAir(),
    expect: () => const [
      ListState<TVSeries>(status: RequestState.loading),
      ListState<TVSeries>(
        status: RequestState.error,
        message: 'Server failure',
      ),
    ],
    verify: (_) {
      verify(mockGetOnTheAirTVSeries.execute()).called(1);
    },
  );
}
