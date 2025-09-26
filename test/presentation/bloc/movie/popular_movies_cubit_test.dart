import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:ditonton/features/movie/presentation/bloc/popular_movies_cubit.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMoviesCubit cubit;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    cubit = PopularMoviesCubit(mockGetPopularMovies);
  });

  tearDown(() => cubit.close());

  blocTest<PopularMoviesCubit, ListState<Movie>>(
    'emits [loading, loaded] when data fetched successfully',
    build: () {
      when(
        mockGetPopularMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      return cubit;
    },
    act: (cubit) => cubit.fetchPopular(),
    expect: () => [
      ListState<Movie>(status: RequestState.loading),
      ListState<Movie>(status: RequestState.loaded, items: testMovieList),
    ],
    verify: (_) {
      verify(mockGetPopularMovies.execute()).called(1);
    },
  );

  blocTest<PopularMoviesCubit, ListState<Movie>>(
    'emits [loading, error] when data fetch fails',
    build: () {
      when(
        mockGetPopularMovies.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server failure')));
      return cubit;
    },
    act: (cubit) => cubit.fetchPopular(),
    expect: () => const [
      ListState<Movie>(status: RequestState.loading),
      ListState<Movie>(status: RequestState.error, message: 'Server failure'),
    ],
    verify: (_) {
      verify(mockGetPopularMovies.execute()).called(1);
    },
  );
}
