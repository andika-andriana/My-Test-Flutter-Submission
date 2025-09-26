import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:ditonton/features/movie/presentation/bloc/now_playing_movies_cubit.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late NowPlayingMoviesCubit cubit;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    cubit = NowPlayingMoviesCubit(mockGetNowPlayingMovies);
  });

  tearDown(() => cubit.close());

  blocTest<NowPlayingMoviesCubit, ListState<Movie>>(
    'emits [loading, loaded] when fetch succeeds',
    build: () {
      when(
        mockGetNowPlayingMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      return cubit;
    },
    act: (cubit) => cubit.fetchNowPlaying(),
    expect: () => [
      ListState<Movie>(status: RequestState.loading),
      ListState<Movie>(status: RequestState.loaded, items: testMovieList),
    ],
    verify: (_) {
      verify(mockGetNowPlayingMovies.execute()).called(1);
    },
  );

  blocTest<NowPlayingMoviesCubit, ListState<Movie>>(
    'emits [loading, error] when fetch fails',
    build: () {
      when(
        mockGetNowPlayingMovies.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server failure')));
      return cubit;
    },
    act: (cubit) => cubit.fetchNowPlaying(),
    expect: () => const [
      ListState<Movie>(status: RequestState.loading),
      ListState<Movie>(status: RequestState.error, message: 'Server failure'),
    ],
    verify: (_) {
      verify(mockGetNowPlayingMovies.execute()).called(1);
    },
  );
}
