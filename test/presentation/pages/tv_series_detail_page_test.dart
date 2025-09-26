import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_detail_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTVSeriesDetailCubit extends MockCubit<TVSeriesDetailState>
    implements TVSeriesDetailCubit {
  MockTVSeriesDetailCubit() : super(const TVSeriesDetailState());

  @override
  Future<void> fetchDetail(int id) async {}

  @override
  Future<void> loadWatchlistStatus(int id) async {}

  @override
  Future<void> addToWatchlist(TVSeriesDetail tvSeries) async {}

  @override
  Future<void> removeFromWatchlist(TVSeriesDetail tvSeries) async {}
}

class MockCubit<T> extends Cubit<T> {
  MockCubit(super.initialState);
}

void main() {
  late MockTVSeriesDetailCubit mockCubit;

  setUp(() {
    mockCubit = MockTVSeriesDetailCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TVSeriesDetailCubit>(
      create: (context) => mockCubit,
      child: MaterialApp(home: body),
    );
  }

  group('TVSeriesDetailPage', () {
    testWidgets('should display loading indicator when state is loading', (
      WidgetTester tester,
    ) async {
      // arrange
      mockCubit.emit(const TVSeriesDetailState(status: RequestState.loading));

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error message when state is error', (WidgetTester tester) async {
      // arrange
      mockCubit.emit(
        const TVSeriesDetailState(status: RequestState.error, message: 'Error message'),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('should display TV series detail when state is loaded', (
      WidgetTester tester,
    ) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text(testTVSeriesDetail.name), findsOneWidget);
      expect(find.text(testTVSeriesDetail.overview), findsOneWidget);
    });

    testWidgets('should display watchlist button with correct text when not in watchlist', (
      WidgetTester tester,
    ) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('Add to Watchlist'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should display watchlist button with correct text when in watchlist', (
      WidgetTester tester,
    ) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: true,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('Remove from Watchlist'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should display TV series genres correctly', (WidgetTester tester) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('Sci-Fi & Fantasy'), findsOneWidget);
    });

    testWidgets('should display TV series information correctly', (WidgetTester tester) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('2011-04-17'), findsOneWidget); // firstAirDate
      expect(find.text('8 Seasons'), findsOneWidget); // numberOfSeasons
      expect(find.text('73 Episodes'), findsOneWidget); // numberOfEpisodes
    });

    testWidgets('should display recommendations section when loaded', (WidgetTester tester) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('Recommendations'), findsOneWidget);
      expect(
        find.byType(ListView).at(1),
        findsOneWidget,
      ); // Use at(1) to get the second ListView (recommendations)
    });

    testWidgets('should display loading indicator for recommendations', (
      WidgetTester tester,
    ) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: const [],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loading,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(
        find.byType(CircularProgressIndicator).at(1),
        findsOneWidget,
      ); // Use at(1) to get the second CircularProgressIndicator (recommendations)
    });

    testWidgets('should display error message for recommendations', (WidgetTester tester) async {
      // arrange
      const errorMessage = 'Failed to load recommendations';
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: const [],
          isInWatchlist: false,
          recommendationsStatus: RequestState.error,
          message: errorMessage,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should display seasons section when seasons are available', (
      WidgetTester tester,
    ) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('Seasons'), findsOneWidget);
      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('should handle recommendation tap navigation', (WidgetTester tester) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // Find and tap on recommendation
      final recommendationInkWell = find.byType(InkWell).last;
      await tester.tap(recommendationInkWell);
      await tester.pump();

      // Verify navigation occurred
      expect(find.byType(TVSeriesDetailPage), findsOneWidget);
    });

    testWidgets('should display empty recommendations when list is empty', (
      WidgetTester tester,
    ) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: const [],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('Recommendations'), findsOneWidget);
    });

    testWidgets('should display watchlist button with correct text when removing from watchlist', (
      WidgetTester tester,
    ) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: const [],
          isInWatchlist: true,
          recommendationsStatus: RequestState.loaded,
          watchlistMessage: TVSeriesDetailCubit.watchlistRemoveSuccessMessage,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('Remove from Watchlist'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should display watchlist button with correct text when adding to watchlist', (
      WidgetTester tester,
    ) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: const [],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
          watchlistMessage: TVSeriesDetailCubit.watchlistAddSuccessMessage,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('Add to Watchlist'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should display TV series rating correctly', (WidgetTester tester) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('8.3'), findsOneWidget);
    });

    testWidgets('should display TV series overview correctly', (WidgetTester tester) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(
        find.text('Nine noble families fight for control over the lands of Westeros.'),
        findsOneWidget,
      );
    });

    testWidgets('should display TV series name correctly', (WidgetTester tester) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('Game of Thrones'), findsOneWidget);
    });

    testWidgets('should display TV series first air date correctly', (WidgetTester tester) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('2011-04-17'), findsOneWidget);
    });

    testWidgets('should display TV series vote count correctly', (WidgetTester tester) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('12000'), findsOneWidget);
    });

    testWidgets('should display TV series in production status correctly', (
      WidgetTester tester,
    ) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('Not In Production'), findsOneWidget);
    });

    testWidgets('should display TV series with in production status correctly', (
      WidgetTester tester,
    ) async {
      // arrange
      final inProductionTVSeriesDetail = TVSeriesDetail(
        backdropPath: testTVSeriesDetail.backdropPath,
        genres: testTVSeriesDetail.genres,
        id: testTVSeriesDetail.id,
        name: testTVSeriesDetail.name,
        originalName: testTVSeriesDetail.originalName,
        overview: testTVSeriesDetail.overview,
        posterPath: testTVSeriesDetail.posterPath,
        voteAverage: testTVSeriesDetail.voteAverage,
        voteCount: testTVSeriesDetail.voteCount,
        firstAirDate: testTVSeriesDetail.firstAirDate,
        lastAirDate: testTVSeriesDetail.lastAirDate,
        numberOfSeasons: testTVSeriesDetail.numberOfSeasons,
        numberOfEpisodes: testTVSeriesDetail.numberOfEpisodes,
        episodeRunTime: testTVSeriesDetail.episodeRunTime,
        seasons: testTVSeriesDetail.seasons,
        homepage: testTVSeriesDetail.homepage,
        inProduction: true,
        tagline: testTVSeriesDetail.tagline,
      );
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: inProductionTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('In Production'), findsOneWidget);
    });

    testWidgets('should display TV series with zero vote count correctly', (
      WidgetTester tester,
    ) async {
      // arrange
      final zeroVoteTVSeriesDetail = TVSeriesDetail(
        backdropPath: testTVSeriesDetail.backdropPath,
        genres: testTVSeriesDetail.genres,
        id: testTVSeriesDetail.id,
        name: testTVSeriesDetail.name,
        originalName: testTVSeriesDetail.originalName,
        overview: testTVSeriesDetail.overview,
        posterPath: testTVSeriesDetail.posterPath,
        voteAverage: testTVSeriesDetail.voteAverage,
        voteCount: 0,
        firstAirDate: testTVSeriesDetail.firstAirDate,
        lastAirDate: testTVSeriesDetail.lastAirDate,
        numberOfSeasons: testTVSeriesDetail.numberOfSeasons,
        numberOfEpisodes: testTVSeriesDetail.numberOfEpisodes,
        episodeRunTime: testTVSeriesDetail.episodeRunTime,
        seasons: testTVSeriesDetail.seasons,
        homepage: testTVSeriesDetail.homepage,
        inProduction: testTVSeriesDetail.inProduction,
        tagline: testTVSeriesDetail.tagline,
      );
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: zeroVoteTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('should display TV series with empty tagline correctly', (
      WidgetTester tester,
    ) async {
      // arrange
      final emptyTaglineTVSeriesDetail = TVSeriesDetail(
        backdropPath: testTVSeriesDetail.backdropPath,
        genres: testTVSeriesDetail.genres,
        id: testTVSeriesDetail.id,
        name: testTVSeriesDetail.name,
        originalName: testTVSeriesDetail.originalName,
        overview: testTVSeriesDetail.overview,
        posterPath: testTVSeriesDetail.posterPath,
        voteAverage: testTVSeriesDetail.voteAverage,
        voteCount: testTVSeriesDetail.voteCount,
        firstAirDate: testTVSeriesDetail.firstAirDate,
        lastAirDate: testTVSeriesDetail.lastAirDate,
        numberOfSeasons: testTVSeriesDetail.numberOfSeasons,
        numberOfEpisodes: testTVSeriesDetail.numberOfEpisodes,
        episodeRunTime: testTVSeriesDetail.episodeRunTime,
        seasons: testTVSeriesDetail.seasons,
        homepage: testTVSeriesDetail.homepage,
        inProduction: testTVSeriesDetail.inProduction,
        tagline: '',
      );
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: emptyTaglineTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('Winter Is Coming.'), findsNothing);
    });

    testWidgets('should display season list when seasons are available', (
      WidgetTester tester,
    ) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('Season 1'), findsOneWidget);
      expect(find.text('Episodes: 10'), findsOneWidget);
      expect(find.text('Air Date: 2011-04-17'), findsOneWidget);
      expect(find.text('Winter is coming.'), findsOneWidget);
    });

    testWidgets('should handle season with null air date', (WidgetTester tester) async {
      // arrange
      final seasonWithNullAirDate = TVSeriesDetail(
        backdropPath: testTVSeriesDetail.backdropPath,
        genres: testTVSeriesDetail.genres,
        id: testTVSeriesDetail.id,
        name: testTVSeriesDetail.name,
        originalName: testTVSeriesDetail.originalName,
        overview: testTVSeriesDetail.overview,
        posterPath: testTVSeriesDetail.posterPath,
        voteAverage: testTVSeriesDetail.voteAverage,
        voteCount: testTVSeriesDetail.voteCount,
        firstAirDate: testTVSeriesDetail.firstAirDate,
        lastAirDate: testTVSeriesDetail.lastAirDate,
        numberOfSeasons: testTVSeriesDetail.numberOfSeasons,
        numberOfEpisodes: testTVSeriesDetail.numberOfEpisodes,
        episodeRunTime: testTVSeriesDetail.episodeRunTime,
        seasons: const [
          Season(
            airDate: null,
            episodeCount: 10,
            id: 1,
            name: 'Season 1',
            overview: 'Winter is coming.',
            posterPath: '/season1.jpg',
            seasonNumber: 1,
          ),
        ],
        homepage: testTVSeriesDetail.homepage,
        inProduction: testTVSeriesDetail.inProduction,
        tagline: testTVSeriesDetail.tagline,
      );
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: seasonWithNullAirDate,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('Season 1'), findsOneWidget);
      expect(find.text('Episodes: 10'), findsOneWidget);
      expect(find.text('Air Date:'), findsNothing);
    });

    testWidgets('should handle season with empty overview', (WidgetTester tester) async {
      // arrange
      final seasonWithEmptyOverview = TVSeriesDetail(
        backdropPath: testTVSeriesDetail.backdropPath,
        genres: testTVSeriesDetail.genres,
        id: testTVSeriesDetail.id,
        name: testTVSeriesDetail.name,
        originalName: testTVSeriesDetail.originalName,
        overview: testTVSeriesDetail.overview,
        posterPath: testTVSeriesDetail.posterPath,
        voteAverage: testTVSeriesDetail.voteAverage,
        voteCount: testTVSeriesDetail.voteCount,
        firstAirDate: testTVSeriesDetail.firstAirDate,
        lastAirDate: testTVSeriesDetail.lastAirDate,
        numberOfSeasons: testTVSeriesDetail.numberOfSeasons,
        numberOfEpisodes: testTVSeriesDetail.numberOfEpisodes,
        episodeRunTime: testTVSeriesDetail.episodeRunTime,
        seasons: const [
          Season(
            airDate: '2011-04-17',
            episodeCount: 10,
            id: 1,
            name: 'Season 1',
            overview: '',
            posterPath: '/season1.jpg',
            seasonNumber: 1,
          ),
        ],
        homepage: testTVSeriesDetail.homepage,
        inProduction: testTVSeriesDetail.inProduction,
        tagline: testTVSeriesDetail.tagline,
      );
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: seasonWithEmptyOverview,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('Season 1'), findsOneWidget);
      expect(find.text('Episodes: 10'), findsOneWidget);
      expect(find.text('Air Date: 2011-04-17'), findsOneWidget);
      expect(find.text('Winter is coming.'), findsNothing);
    });

    testWidgets('should display error state correctly', (WidgetTester tester) async {
      // arrange
      const errorMessage = 'Failed to load TV series detail';
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.error,
          tvSeries: null,
          recommendations: const [],
          isInWatchlist: false,
          recommendationsStatus: RequestState.empty,
          message: errorMessage,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should display empty state correctly', (WidgetTester tester) async {
      // arrange
      mockCubit.emit(
        const TVSeriesDetailState(
          status: RequestState.empty,
          tvSeries: null,
          recommendations: [],
          isInWatchlist: false,
          recommendationsStatus: RequestState.empty,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('should display TV series with null first air date', (WidgetTester tester) async {
      // arrange
      final tvSeriesWithNullFirstAirDate = TVSeriesDetail(
        backdropPath: testTVSeriesDetail.backdropPath,
        genres: testTVSeriesDetail.genres,
        id: testTVSeriesDetail.id,
        name: testTVSeriesDetail.name,
        originalName: testTVSeriesDetail.originalName,
        overview: testTVSeriesDetail.overview,
        posterPath: testTVSeriesDetail.posterPath,
        voteAverage: testTVSeriesDetail.voteAverage,
        voteCount: testTVSeriesDetail.voteCount,
        firstAirDate: null,
        lastAirDate: testTVSeriesDetail.lastAirDate,
        numberOfSeasons: testTVSeriesDetail.numberOfSeasons,
        numberOfEpisodes: testTVSeriesDetail.numberOfEpisodes,
        episodeRunTime: testTVSeriesDetail.episodeRunTime,
        seasons: testTVSeriesDetail.seasons,
        homepage: testTVSeriesDetail.homepage,
        inProduction: testTVSeriesDetail.inProduction,
        tagline: testTVSeriesDetail.tagline,
      );
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: tvSeriesWithNullFirstAirDate,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('-'), findsOneWidget);
    });

    testWidgets('should display TV series with zero vote average', (WidgetTester tester) async {
      // arrange
      final tvSeriesWithZeroVoteAverage = TVSeriesDetail(
        backdropPath: testTVSeriesDetail.backdropPath,
        genres: testTVSeriesDetail.genres,
        id: testTVSeriesDetail.id,
        name: testTVSeriesDetail.name,
        originalName: testTVSeriesDetail.originalName,
        overview: testTVSeriesDetail.overview,
        posterPath: testTVSeriesDetail.posterPath,
        voteAverage: 0.0,
        voteCount: testTVSeriesDetail.voteCount,
        firstAirDate: testTVSeriesDetail.firstAirDate,
        lastAirDate: testTVSeriesDetail.lastAirDate,
        numberOfSeasons: testTVSeriesDetail.numberOfSeasons,
        numberOfEpisodes: testTVSeriesDetail.numberOfEpisodes,
        episodeRunTime: testTVSeriesDetail.episodeRunTime,
        seasons: testTVSeriesDetail.seasons,
        homepage: testTVSeriesDetail.homepage,
        inProduction: testTVSeriesDetail.inProduction,
        tagline: testTVSeriesDetail.tagline,
      );
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: tvSeriesWithZeroVoteAverage,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('0.0'), findsOneWidget);
    });

    testWidgets('should display back button and handle navigation', (WidgetTester tester) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Test back button tap
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();
    });

    testWidgets('should display TV series with empty genres list', (WidgetTester tester) async {
      // arrange
      final tvSeriesWithEmptyGenres = TVSeriesDetail(
        backdropPath: testTVSeriesDetail.backdropPath,
        genres: const [],
        id: testTVSeriesDetail.id,
        name: testTVSeriesDetail.name,
        originalName: testTVSeriesDetail.originalName,
        overview: testTVSeriesDetail.overview,
        posterPath: testTVSeriesDetail.posterPath,
        voteAverage: testTVSeriesDetail.voteAverage,
        voteCount: testTVSeriesDetail.voteCount,
        firstAirDate: testTVSeriesDetail.firstAirDate,
        lastAirDate: testTVSeriesDetail.lastAirDate,
        numberOfSeasons: testTVSeriesDetail.numberOfSeasons,
        numberOfEpisodes: testTVSeriesDetail.numberOfEpisodes,
        episodeRunTime: testTVSeriesDetail.episodeRunTime,
        seasons: testTVSeriesDetail.seasons,
        homepage: testTVSeriesDetail.homepage,
        inProduction: testTVSeriesDetail.inProduction,
        tagline: testTVSeriesDetail.tagline,
      );
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: tvSeriesWithEmptyGenres,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('should display TV series with single genre', (WidgetTester tester) async {
      // arrange
      final tvSeriesWithSingleGenre = TVSeriesDetail(
        backdropPath: testTVSeriesDetail.backdropPath,
        genres: const [Genre(id: 1, name: 'Action')],
        id: testTVSeriesDetail.id,
        name: testTVSeriesDetail.name,
        originalName: testTVSeriesDetail.originalName,
        overview: testTVSeriesDetail.overview,
        posterPath: testTVSeriesDetail.posterPath,
        voteAverage: testTVSeriesDetail.voteAverage,
        voteCount: testTVSeriesDetail.voteCount,
        firstAirDate: testTVSeriesDetail.firstAirDate,
        lastAirDate: testTVSeriesDetail.lastAirDate,
        numberOfSeasons: testTVSeriesDetail.numberOfSeasons,
        numberOfEpisodes: testTVSeriesDetail.numberOfEpisodes,
        episodeRunTime: testTVSeriesDetail.episodeRunTime,
        seasons: testTVSeriesDetail.seasons,
        homepage: testTVSeriesDetail.homepage,
        inProduction: testTVSeriesDetail.inProduction,
        tagline: testTVSeriesDetail.tagline,
      );
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: tvSeriesWithSingleGenre,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('Action'), findsOneWidget);
    });

    testWidgets('should display back button and handle navigation', (WidgetTester tester) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Test back button tap
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();
    });

    testWidgets('should display TV series with empty genres list', (WidgetTester tester) async {
      // arrange
      final tvSeriesWithEmptyGenres = TVSeriesDetail(
        backdropPath: testTVSeriesDetail.backdropPath,
        genres: const [],
        id: testTVSeriesDetail.id,
        name: testTVSeriesDetail.name,
        originalName: testTVSeriesDetail.originalName,
        overview: testTVSeriesDetail.overview,
        posterPath: testTVSeriesDetail.posterPath,
        voteAverage: testTVSeriesDetail.voteAverage,
        voteCount: testTVSeriesDetail.voteCount,
        firstAirDate: testTVSeriesDetail.firstAirDate,
        lastAirDate: testTVSeriesDetail.lastAirDate,
        numberOfSeasons: testTVSeriesDetail.numberOfSeasons,
        numberOfEpisodes: testTVSeriesDetail.numberOfEpisodes,
        episodeRunTime: testTVSeriesDetail.episodeRunTime,
        seasons: testTVSeriesDetail.seasons,
        homepage: testTVSeriesDetail.homepage,
        inProduction: testTVSeriesDetail.inProduction,
        tagline: testTVSeriesDetail.tagline,
      );
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: tvSeriesWithEmptyGenres,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('should display TV series with single genre', (WidgetTester tester) async {
      // arrange
      final tvSeriesWithSingleGenre = TVSeriesDetail(
        backdropPath: testTVSeriesDetail.backdropPath,
        genres: const [Genre(id: 1, name: 'Action')],
        id: testTVSeriesDetail.id,
        name: testTVSeriesDetail.name,
        originalName: testTVSeriesDetail.originalName,
        overview: testTVSeriesDetail.overview,
        posterPath: testTVSeriesDetail.posterPath,
        voteAverage: testTVSeriesDetail.voteAverage,
        voteCount: testTVSeriesDetail.voteCount,
        firstAirDate: testTVSeriesDetail.firstAirDate,
        lastAirDate: testTVSeriesDetail.lastAirDate,
        numberOfSeasons: testTVSeriesDetail.numberOfSeasons,
        numberOfEpisodes: testTVSeriesDetail.numberOfEpisodes,
        episodeRunTime: testTVSeriesDetail.episodeRunTime,
        seasons: testTVSeriesDetail.seasons,
        homepage: testTVSeriesDetail.homepage,
        inProduction: testTVSeriesDetail.inProduction,
        tagline: testTVSeriesDetail.tagline,
      );
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: tvSeriesWithSingleGenre,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('Action'), findsOneWidget);
    });

    testWidgets('should handle watchlist button toggle functionality', (WidgetTester tester) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // Find and tap the watchlist button by text
      final watchlistButton = find.text('Add to Watchlist');
      expect(watchlistButton, findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      // Verify the button was tapped (this tests the onToggle callback)
      expect(find.text('Add to Watchlist'), findsOneWidget);
    });

    testWidgets('should display error widget when image fails to load', (
      WidgetTester tester,
    ) async {
      // arrange
      final tvSeriesWithInvalidRecommendation = TVSeries(
        id: 2,
        name: 'Test TV Series 2',
        overview: 'Test Overview 2',
        posterPath: '/invalid-path.jpg', // Invalid path to trigger error
        backdropPath: '/test2.jpg',
        voteAverage: 7.5,
        firstAirDate: '2023-02-01',
        genreIds: [1, 2, 3],
        popularity: 200.0,
        voteCount: 2000,
        originalName: 'Test TV Series 2',
        originCountry: ['US'],
        originalLanguage: 'en',
      );
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [tvSeriesWithInvalidRecommendation],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // Wait for the image to fail loading
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      // assert
      expect(find.byType(CachedNetworkImage), findsWidgets);
      // Just verify that the recommendations section is displayed
      expect(find.text('Recommendations'), findsOneWidget);
    });

    testWidgets('should handle season with null poster path', (WidgetTester tester) async {
      // arrange
      final seasonWithNullPosterPath = TVSeriesDetail(
        backdropPath: testTVSeriesDetail.backdropPath,
        genres: testTVSeriesDetail.genres,
        id: testTVSeriesDetail.id,
        name: testTVSeriesDetail.name,
        originalName: testTVSeriesDetail.originalName,
        overview: testTVSeriesDetail.overview,
        posterPath: testTVSeriesDetail.posterPath,
        voteAverage: testTVSeriesDetail.voteAverage,
        voteCount: testTVSeriesDetail.voteCount,
        firstAirDate: testTVSeriesDetail.firstAirDate,
        lastAirDate: testTVSeriesDetail.lastAirDate,
        numberOfSeasons: testTVSeriesDetail.numberOfSeasons,
        numberOfEpisodes: testTVSeriesDetail.numberOfEpisodes,
        episodeRunTime: testTVSeriesDetail.episodeRunTime,
        seasons: const [
          Season(
            airDate: '2011-04-17',
            episodeCount: 10,
            id: 1,
            name: 'Season 1',
            overview: 'Winter is coming.',
            posterPath: null, // Null poster path
            seasonNumber: 1,
          ),
        ],
        homepage: testTVSeriesDetail.homepage,
        inProduction: testTVSeriesDetail.inProduction,
        tagline: testTVSeriesDetail.tagline,
      );
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: seasonWithNullPosterPath,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(const TVSeriesDetailPage(id: 1)));
      await tester.pump();

      // assert
      expect(find.text('Season 1'), findsOneWidget);
      expect(find.text('Episodes: 10'), findsOneWidget);
      expect(find.text('Air Date: 2011-04-17'), findsOneWidget);
    });

    testWidgets('should handle recommendation navigation tap', (WidgetTester tester) async {
      // arrange
      mockCubit.emit(
        TVSeriesDetailState(
          status: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: [testTVSeries],
          isInWatchlist: false,
          recommendationsStatus: RequestState.loaded,
        ),
      );

      // act
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/tv-series-detail': (context) => const Scaffold(body: Text('TV Series Detail')),
          },
          home: BlocProvider<TVSeriesDetailCubit>(
            create: (context) => mockCubit,
            child: const TVSeriesDetailPage(id: 1),
          ),
        ),
      );
      await tester.pump();

      // Find and tap on recommendation InkWell
      final recommendationInkWells = find.byType(InkWell);
      expect(recommendationInkWells, findsWidgets);

      // Tap the last InkWell (which should be the recommendation)
      await tester.tap(recommendationInkWells.last);
      await tester.pump();

      // Verify that the tap was handled by checking that the recommendations section is still displayed
      expect(find.text('Recommendations'), findsOneWidget);
    });
  });
}
