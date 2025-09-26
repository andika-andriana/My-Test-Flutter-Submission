import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:ditonton/features/movie/presentation/bloc/watchlist_movies_cubit.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late WatchlistMoviesCubit cubit;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    cubit = WatchlistMoviesCubit(mockGetWatchlistMovies);
  });

  tearDown(() => cubit.close());

  blocTest<WatchlistMoviesCubit, ListState<Movie>>(
    'emits [loading, loaded] when watchlist fetched successfully',
    build: () {
      when(
        mockGetWatchlistMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      return cubit;
    },
    act: (cubit) => cubit.fetchWatchlist(),
    expect: () => [
      ListState<Movie>(status: RequestState.loading),
      ListState<Movie>(status: RequestState.loaded, items: testMovieList),
    ],
    verify: (_) {
      verify(mockGetWatchlistMovies.execute()).called(1);
    },
  );

  blocTest<WatchlistMoviesCubit, ListState<Movie>>(
    'emits [loading, error] when watchlist fetch fails',
    build: () {
      when(mockGetWatchlistMovies.execute()).thenAnswer(
        (_) async => const Left(DatabaseFailure('Database failure')),
      );
      return cubit;
    },
    act: (cubit) => cubit.fetchWatchlist(),
    expect: () => const [
      ListState<Movie>(status: RequestState.loading),
      ListState<Movie>(status: RequestState.error, message: 'Database failure'),
    ],
    verify: (_) {
      verify(mockGetWatchlistMovies.execute()).called(1);
    },
  );
}
