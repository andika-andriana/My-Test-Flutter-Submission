import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:ditonton/features/movie/presentation/bloc/top_rated_movies_cubit.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMoviesCubit cubit;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    cubit = TopRatedMoviesCubit(mockGetTopRatedMovies);
  });

  tearDown(() => cubit.close());

  blocTest<TopRatedMoviesCubit, ListState<Movie>>(
    'emits [loading, loaded] when fetch succeeds',
    build: () {
      when(
        mockGetTopRatedMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      return cubit;
    },
    act: (cubit) => cubit.fetchTopRated(),
    expect: () => [
      ListState<Movie>(status: RequestState.loading),
      ListState<Movie>(status: RequestState.loaded, items: testMovieList),
    ],
    verify: (_) {
      verify(mockGetTopRatedMovies.execute()).called(1);
    },
  );

  blocTest<TopRatedMoviesCubit, ListState<Movie>>(
    'emits [loading, error] when fetch fails',
    build: () {
      when(
        mockGetTopRatedMovies.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server failure')));
      return cubit;
    },
    act: (cubit) => cubit.fetchTopRated(),
    expect: () => const [
      ListState<Movie>(status: RequestState.loading),
      ListState<Movie>(status: RequestState.error, message: 'Server failure'),
    ],
    verify: (_) {
      verify(mockGetTopRatedMovies.execute()).called(1);
    },
  );
}
