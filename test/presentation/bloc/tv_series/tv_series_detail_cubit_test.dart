import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_detail_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetTVSeriesDetail mockGetTVSeriesDetail;
  late MockGetTVSeriesRecommendations mockGetTVSeriesRecommendations;
  late MockGetTVWatchlistStatus mockGetTVWatchlistStatus;
  late MockSaveTVWatchlist mockSaveTVWatchlist;
  late MockRemoveTVWatchlist mockRemoveTVWatchlist;
  late TVSeriesDetailCubit cubit;

  setUp(() {
    mockGetTVSeriesDetail = MockGetTVSeriesDetail();
    mockGetTVSeriesRecommendations = MockGetTVSeriesRecommendations();
    mockGetTVWatchlistStatus = MockGetTVWatchlistStatus();
    mockSaveTVWatchlist = MockSaveTVWatchlist();
    mockRemoveTVWatchlist = MockRemoveTVWatchlist();
    cubit = TVSeriesDetailCubit(
      mockGetTVSeriesDetail,
      mockGetTVSeriesRecommendations,
      mockGetTVWatchlistStatus,
      mockSaveTVWatchlist,
      mockRemoveTVWatchlist,
    );
  });

  tearDown(() => cubit.close());

  blocTest<TVSeriesDetailCubit, TVSeriesDetailState>(
    'emits states for successful detail and recommendations fetch',
    build: () {
      when(mockGetTVSeriesDetail.execute(1)).thenAnswer((_) async => Right(testTVSeriesDetail));
      when(
        mockGetTVSeriesRecommendations.execute(1),
      ).thenAnswer((_) async => Right(testTVSeriesList));
      return cubit;
    },
    act: (cubit) => cubit.fetchDetail(1),
    expect: () => [
      const TVSeriesDetailState(status: RequestState.loading, message: ''),
      TVSeriesDetailState(status: RequestState.loaded, tvSeries: testTVSeriesDetail, message: ''),
      TVSeriesDetailState(
        status: RequestState.loaded,
        tvSeries: testTVSeriesDetail,
        recommendationsStatus: RequestState.loading,
        message: '',
      ),
      TVSeriesDetailState(
        status: RequestState.loaded,
        tvSeries: testTVSeriesDetail,
        recommendationsStatus: RequestState.loaded,
        recommendations: testTVSeriesList,
        message: '',
      ),
    ],
  );

  blocTest<TVSeriesDetailCubit, TVSeriesDetailState>(
    'emits error state when detail fetch fails',
    build: () {
      when(
        mockGetTVSeriesDetail.execute(1),
      ).thenAnswer((_) async => const Left(ServerFailure('Server failure')));
      return cubit;
    },
    act: (cubit) => cubit.fetchDetail(1),
    expect: () => const [
      TVSeriesDetailState(status: RequestState.loading, message: ''),
      TVSeriesDetailState(status: RequestState.error, message: 'Server failure'),
    ],
    verify: (_) {
      verify(mockGetTVSeriesDetail.execute(1)).called(1);
      verifyNever(mockGetTVSeriesRecommendations.execute(1));
    },
  );

  blocTest<TVSeriesDetailCubit, TVSeriesDetailState>(
    'emits error state when recommendations fetch fails',
    build: () {
      when(mockGetTVSeriesDetail.execute(1)).thenAnswer((_) async => Right(testTVSeriesDetail));
      when(
        mockGetTVSeriesRecommendations.execute(1),
      ).thenAnswer((_) async => const Left(ServerFailure('Server failure')));
      return cubit;
    },
    act: (cubit) => cubit.fetchDetail(1),
    expect: () => [
      const TVSeriesDetailState(status: RequestState.loading, message: ''),
      TVSeriesDetailState(status: RequestState.loaded, tvSeries: testTVSeriesDetail, message: ''),
      TVSeriesDetailState(
        status: RequestState.loaded,
        tvSeries: testTVSeriesDetail,
        recommendationsStatus: RequestState.loading,
        message: '',
      ),
      TVSeriesDetailState(
        status: RequestState.loaded,
        tvSeries: testTVSeriesDetail,
        recommendationsStatus: RequestState.error,
        message: 'Server failure',
      ),
    ],
  );

  blocTest<TVSeriesDetailCubit, TVSeriesDetailState>(
    'updates state when addToWatchlist succeeds',
    build: () {
      when(
        mockSaveTVWatchlist.execute(testTVSeriesDetail),
      ).thenAnswer((_) async => const Right('Added to Watchlist'));
      return cubit;
    },
    act: (cubit) => cubit.addToWatchlist(testTVSeriesDetail),
    expect: () => const [
      TVSeriesDetailState(watchlistMessage: 'Added to Watchlist', isInWatchlist: true),
    ],
    verify: (_) {
      verify(mockSaveTVWatchlist.execute(testTVSeriesDetail)).called(1);
    },
  );

  blocTest<TVSeriesDetailCubit, TVSeriesDetailState>(
    'updates state when removeFromWatchlist succeeds',
    build: () {
      when(
        mockRemoveTVWatchlist.execute(testTVSeriesDetail),
      ).thenAnswer((_) async => const Right('Removed from Watchlist'));
      return cubit;
    },
    seed: () => const TVSeriesDetailState(isInWatchlist: true),
    act: (cubit) => cubit.removeFromWatchlist(testTVSeriesDetail),
    expect: () => const [
      TVSeriesDetailState(isInWatchlist: false, watchlistMessage: 'Removed from Watchlist'),
    ],
    verify: (_) {
      verify(mockRemoveTVWatchlist.execute(testTVSeriesDetail)).called(1);
    },
  );

  blocTest<TVSeriesDetailCubit, TVSeriesDetailState>(
    'updates state when loadWatchlistStatus called',
    build: () {
      when(mockGetTVWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      return cubit;
    },
    act: (cubit) => cubit.loadWatchlistStatus(1),
    expect: () => const [TVSeriesDetailState(isInWatchlist: true)],
    verify: (_) {
      verify(mockGetTVWatchlistStatus.execute(1)).called(1);
    },
  );

  blocTest<TVSeriesDetailCubit, TVSeriesDetailState>(
    'updates state when addToWatchlist fails',
    build: () {
      when(
        mockSaveTVWatchlist.execute(testTVSeriesDetail),
      ).thenAnswer((_) async => const Left(DatabaseFailure('Database failure')));
      return cubit;
    },
    act: (cubit) => cubit.addToWatchlist(testTVSeriesDetail),
    expect: () => const [
      TVSeriesDetailState(watchlistMessage: 'Database failure', isInWatchlist: false),
    ],
    verify: (_) {
      verify(mockSaveTVWatchlist.execute(testTVSeriesDetail)).called(1);
    },
  );

  blocTest<TVSeriesDetailCubit, TVSeriesDetailState>(
    'updates state when removeFromWatchlist fails',
    build: () {
      when(
        mockRemoveTVWatchlist.execute(testTVSeriesDetail),
      ).thenAnswer((_) async => const Left(DatabaseFailure('Database failure')));
      return cubit;
    },
    seed: () => const TVSeriesDetailState(isInWatchlist: true),
    act: (cubit) => cubit.removeFromWatchlist(testTVSeriesDetail),
    expect: () => const [
      TVSeriesDetailState(isInWatchlist: true, watchlistMessage: 'Database failure'),
    ],
    verify: (_) {
      verify(mockRemoveTVWatchlist.execute(testTVSeriesDetail)).called(1);
    },
  );
}
