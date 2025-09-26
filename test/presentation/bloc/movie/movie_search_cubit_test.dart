import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:ditonton/features/movie/presentation/bloc/movie_search_cubit.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockSearchMovies mockSearchMovies;
  late MovieSearchCubit cubit;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    cubit = MovieSearchCubit(mockSearchMovies);
  });

  tearDown(() => cubit.close());

  blocTest<MovieSearchCubit, ListState<Movie>>(
    'emits [loading, loaded] when search succeeds',
    build: () {
      when(mockSearchMovies.execute('spider')).thenAnswer((_) async => Right(testMovieList));
      return cubit;
    },
    act: (cubit) => cubit.search('spider'),
    expect: () => [
      ListState<Movie>(status: RequestState.loading),
      ListState<Movie>(status: RequestState.loaded, items: testMovieList),
    ],
    verify: (_) {
      verify(mockSearchMovies.execute('spider')).called(1);
    },
  );

  blocTest<MovieSearchCubit, ListState<Movie>>(
    'emits [loading, error] when search fails',
    build: () {
      when(
        mockSearchMovies.execute('spider'),
      ).thenAnswer((_) async => const Left(ServerFailure('Server failure')));
      return cubit;
    },
    act: (cubit) => cubit.search('spider'),
    expect: () => const [
      ListState<Movie>(status: RequestState.loading),
      ListState<Movie>(status: RequestState.error, message: 'Server failure'),
    ],
    verify: (_) {
      verify(mockSearchMovies.execute('spider')).called(1);
    },
  );

  blocTest<MovieSearchCubit, ListState<Movie>>(
    'emits empty state when query is empty',
    build: () => cubit,
    act: (cubit) => cubit.search(''),
    expect: () => const [ListState<Movie>()],
    verify: (_) {
      verifyNever(mockSearchMovies.execute(any));
    },
  );
}
