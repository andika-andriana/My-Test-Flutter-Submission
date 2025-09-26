import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton/features/movie/presentation/bloc/movie_detail_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late MovieDetailCubit cubit;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    cubit = MovieDetailCubit(
      mockGetMovieDetail,
      mockGetMovieRecommendations,
      mockGetWatchListStatus,
      mockSaveWatchlist,
      mockRemoveWatchlist,
    );
  });

  tearDown(() => cubit.close());

  blocTest<MovieDetailCubit, MovieDetailState>(
    'emits states for successful detail and recommendations fetch',
    build: () {
      when(mockGetMovieDetail.execute(1)).thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(1)).thenAnswer((_) async => Right(testMovieList));
      return cubit;
    },
    act: (cubit) => cubit.fetchDetail(1),
    expect: () => [
      const MovieDetailState(status: RequestState.loading, message: ''),
      MovieDetailState(status: RequestState.loaded, movie: testMovieDetail, message: ''),
      MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.loading,
        message: '',
      ),
      MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.loaded,
        recommendations: testMovieList,
        message: '',
      ),
    ],
    verify: (_) {
      verify(mockGetMovieDetail.execute(1)).called(1);
      verify(mockGetMovieRecommendations.execute(1)).called(1);
    },
  );

  blocTest<MovieDetailCubit, MovieDetailState>(
    'emits error state when detail fetch fails',
    build: () {
      when(
        mockGetMovieDetail.execute(1),
      ).thenAnswer((_) async => const Left(ServerFailure('Server failure')));
      return cubit;
    },
    act: (cubit) => cubit.fetchDetail(1),
    expect: () => const [
      MovieDetailState(status: RequestState.loading, message: ''),
      MovieDetailState(status: RequestState.error, message: 'Server failure'),
    ],
    verify: (_) {
      verify(mockGetMovieDetail.execute(1)).called(1);
      verifyNever(mockGetMovieRecommendations.execute(1));
    },
  );

  blocTest<MovieDetailCubit, MovieDetailState>(
    'emits error state when recommendations fetch fails',
    build: () {
      when(mockGetMovieDetail.execute(1)).thenAnswer((_) async => Right(testMovieDetail));
      when(
        mockGetMovieRecommendations.execute(1),
      ).thenAnswer((_) async => const Left(ServerFailure('Server failure')));
      return cubit;
    },
    act: (cubit) => cubit.fetchDetail(1),
    expect: () => [
      const MovieDetailState(status: RequestState.loading, message: ''),
      MovieDetailState(status: RequestState.loaded, movie: testMovieDetail, message: ''),
      MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.loading,
        message: '',
      ),
      MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.error,
        message: 'Server failure',
      ),
    ],
  );

  blocTest<MovieDetailCubit, MovieDetailState>(
    'updates state when addToWatchlist succeeds',
    build: () {
      when(
        mockSaveWatchlist.execute(testMovieDetail),
      ).thenAnswer((_) async => const Right('Added to Watchlist'));
      return cubit;
    },
    act: (cubit) => cubit.addToWatchlist(testMovieDetail),
    expect: () => const [
      MovieDetailState(watchlistMessage: 'Added to Watchlist', isInWatchlist: true),
    ],
    verify: (_) {
      verify(mockSaveWatchlist.execute(testMovieDetail)).called(1);
    },
  );

  blocTest<MovieDetailCubit, MovieDetailState>(
    'updates state when removeFromWatchlist succeeds',
    build: () {
      when(
        mockRemoveWatchlist.execute(testMovieDetail),
      ).thenAnswer((_) async => const Right('Removed from Watchlist'));
      return cubit;
    },
    seed: () => const MovieDetailState(isInWatchlist: true),
    act: (cubit) => cubit.removeFromWatchlist(testMovieDetail),
    expect: () => const [
      MovieDetailState(isInWatchlist: false, watchlistMessage: 'Removed from Watchlist'),
    ],
    verify: (_) {
      verify(mockRemoveWatchlist.execute(testMovieDetail)).called(1);
    },
  );

  blocTest<MovieDetailCubit, MovieDetailState>(
    'updates state when loadWatchlistStatus called',
    build: () {
      when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => true);
      return cubit;
    },
    act: (cubit) => cubit.loadWatchlistStatus(1),
    expect: () => const [MovieDetailState(isInWatchlist: true)],
    verify: (_) {
      verify(mockGetWatchListStatus.execute(1)).called(1);
    },
  );

  blocTest<MovieDetailCubit, MovieDetailState>(
    'updates state when addToWatchlist fails',
    build: () {
      when(
        mockSaveWatchlist.execute(testMovieDetail),
      ).thenAnswer((_) async => const Left(DatabaseFailure('Database failure')));
      return cubit;
    },
    act: (cubit) => cubit.addToWatchlist(testMovieDetail),
    expect: () => const [
      MovieDetailState(watchlistMessage: 'Database failure', isInWatchlist: false),
    ],
    verify: (_) {
      verify(mockSaveWatchlist.execute(testMovieDetail)).called(1);
    },
  );

  blocTest<MovieDetailCubit, MovieDetailState>(
    'updates state when removeFromWatchlist fails',
    build: () {
      when(
        mockRemoveWatchlist.execute(testMovieDetail),
      ).thenAnswer((_) async => const Left(DatabaseFailure('Database failure')));
      return cubit;
    },
    seed: () => const MovieDetailState(isInWatchlist: true),
    act: (cubit) => cubit.removeFromWatchlist(testMovieDetail),
    expect: () => const [
      MovieDetailState(isInWatchlist: true, watchlistMessage: 'Database failure'),
    ],
    verify: (_) {
      verify(mockRemoveWatchlist.execute(testMovieDetail)).called(1);
    },
  );
}
