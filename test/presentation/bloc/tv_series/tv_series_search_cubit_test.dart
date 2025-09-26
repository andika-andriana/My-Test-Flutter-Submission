import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_search_cubit.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockSearchTVSeries mockSearchTVSeries;
  late TVSeriesSearchCubit cubit;

  setUp(() {
    mockSearchTVSeries = MockSearchTVSeries();
    cubit = TVSeriesSearchCubit(mockSearchTVSeries);
  });

  tearDown(() => cubit.close());

  blocTest<TVSeriesSearchCubit, ListState<TVSeries>>(
    'emits [loading, loaded] when search succeeds',
    build: () {
      when(mockSearchTVSeries.execute('thrones')).thenAnswer((_) async => Right(testTVSeriesList));
      return cubit;
    },
    act: (cubit) => cubit.search('thrones'),
    expect: () => [
      ListState<TVSeries>(status: RequestState.loading),
      ListState<TVSeries>(status: RequestState.loaded, items: testTVSeriesList),
    ],
    verify: (_) {
      verify(mockSearchTVSeries.execute('thrones')).called(1);
    },
  );

  blocTest<TVSeriesSearchCubit, ListState<TVSeries>>(
    'emits [loading, error] when search fails',
    build: () {
      when(
        mockSearchTVSeries.execute('thrones'),
      ).thenAnswer((_) async => const Left(ServerFailure('Server failure')));
      return cubit;
    },
    act: (cubit) => cubit.search('thrones'),
    expect: () => const [
      ListState<TVSeries>(status: RequestState.loading),
      ListState<TVSeries>(status: RequestState.error, message: 'Server failure'),
    ],
    verify: (_) {
      verify(mockSearchTVSeries.execute('thrones')).called(1);
    },
  );

  blocTest<TVSeriesSearchCubit, ListState<TVSeries>>(
    'emits empty state when query is empty',
    build: () => cubit,
    act: (cubit) => cubit.search(''),
    expect: () => const [ListState<TVSeries>()],
    verify: (_) {
      verifyNever(mockSearchTVSeries.execute(any));
    },
  );
}
